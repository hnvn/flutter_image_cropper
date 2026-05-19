package vn.hunghd.flutter.plugins.imagecropper;

import android.graphics.RectF;

/**
 * Touch math for locked-aspect corner drags on uCrop's {@code OverlayView}.
 * Adapted from the approach discussed in Yalantis/uCrop#405.
 */
final class CropTouchMath {

    private CropTouchMath() {
    }

    /**
     * Remaps a corner drag so the crop rect keeps {@code ratio} (width / height).
     */
    static float[] adjustCornerForAspectRatio(
            final int corner,
            final float ratio,
            final float touchX,
            final float touchY,
            final RectF cropRect) {
        if (corner < 0 || corner > 3 || ratio <= 0f) {
            return new float[]{touchX, touchY};
        }
        float k = 1f / ratio;
        if (corner == 1 || corner == 3) {
            k = -k;
        }
        final float anchorX = (corner == 0 || corner == 3) ? cropRect.left : cropRect.right;
        final float anchorY = (corner == 0 || corner == 1) ? cropRect.top : cropRect.bottom;
        final float kk1 = k * k + 1f;
        final float tx = ((anchorX * k + touchY - anchorY) * k + touchX) / kk1;
        final float ty = ((touchY * k + touchX - anchorX) * k + anchorY) / kk1;
        return new float[]{tx, ty};
    }

    /**
     * Builds the crop rect that {@code OverlayView} would produce for a corner drag.
     */
    static RectF rectForCornerDrag(
            final int corner,
            final float touchX,
            final float touchY,
            final RectF cropRect,
            final int minSizePx) {
        final RectF result = new RectF(cropRect);
        switch (corner) {
            case 0:
                result.set(touchX, touchY, cropRect.right, cropRect.bottom);
                break;
            case 1:
                result.set(cropRect.left, touchY, touchX, cropRect.bottom);
                break;
            case 2:
                result.set(cropRect.left, cropRect.top, touchX, touchY);
                break;
            case 3:
                result.set(touchX, cropRect.top, cropRect.right, touchY);
                break;
            default:
                return result;
        }
        normalizeMinSize(result, minSizePx);
        return result;
    }

    /**
     * Clamps {@code crop} so it never exceeds {@code max} (shrink-only, iOS parity).
     * The dragged {@code corner} stays pinned to the user's touch as much as possible.
     */
    static void clampCropRectInsideMax(
            final RectF crop,
            final RectF max,
            final int corner,
            final float aspectRatio,
            final boolean lockAspectRatio,
            final int minSizePx) {
        if (fitsInside(crop, max)) {
            return;
        }
        float width = Math.min(crop.width(), max.width());
        float height = Math.min(crop.height(), max.height());
        if (lockAspectRatio && aspectRatio > 0f) {
            if (width / height > aspectRatio) {
                width = height * aspectRatio;
            } else {
                height = width / aspectRatio;
            }
            width = Math.min(width, max.width());
            height = Math.min(height, max.height());
        }
        width = Math.max(width, minSizePx);
        height = Math.max(height, minSizePx);
        final float anchorX;
        final float anchorY;
        switch (corner) {
            case 0:
                anchorX = crop.right;
                anchorY = crop.bottom;
                crop.set(anchorX - width, anchorY - height, anchorX, anchorY);
                break;
            case 1:
                anchorX = crop.left;
                anchorY = crop.bottom;
                crop.set(anchorX, anchorY - height, anchorX + width, anchorY);
                break;
            case 2:
                anchorX = crop.left;
                anchorY = crop.top;
                crop.set(anchorX, anchorY, anchorX + width, anchorY + height);
                break;
            case 3:
                anchorX = crop.right;
                anchorY = crop.top;
                crop.set(anchorX - width, anchorY, anchorX, anchorY + height);
                break;
            default:
                crop.set(
                        crop.centerX() - width / 2f,
                        crop.centerY() - height / 2f,
                        crop.centerX() + width / 2f,
                        crop.centerY() + height / 2f);
                break;
        }
        if (crop.left < max.left) {
            crop.offset(max.left - crop.left, 0f);
        }
        if (crop.top < max.top) {
            crop.offset(0f, max.top - crop.top);
        }
        if (crop.right > max.right) {
            crop.offset(max.right - crop.right, 0f);
        }
        if (crop.bottom > max.bottom) {
            crop.offset(0f, max.bottom - crop.bottom);
        }
        normalizeMinSize(crop, minSizePx);
    }

    private static boolean fitsInside(final RectF inner, final RectF outer) {
        return inner.width() <= outer.width() + 0.5f
                && inner.height() <= outer.height() + 0.5f
                && inner.left >= outer.left - 0.5f
                && inner.top >= outer.top - 0.5f
                && inner.right <= outer.right + 0.5f
                && inner.bottom <= outer.bottom + 0.5f;
    }

    private static void normalizeMinSize(final RectF rect, final int minSizePx) {
        if (rect.width() < minSizePx) {
            final float cx = rect.centerX();
            rect.left = cx - minSizePx / 2f;
            rect.right = cx + minSizePx / 2f;
        }
        if (rect.height() < minSizePx) {
            final float cy = rect.centerY();
            rect.top = cy - minSizePx / 2f;
            rect.bottom = cy + minSizePx / 2f;
        }
    }
}
