package vn.hunghd.flutter.plugins.imagecropper;

import android.graphics.RectF;
import android.os.Bundle;
import android.view.MotionEvent;

import com.yalantis.ucrop.UCrop;
import com.yalantis.ucrop.UCropActivity;
import com.yalantis.ucrop.callback.CropBoundsChangeListener;
import com.yalantis.ucrop.callback.OverlayViewChangeListener;
import com.yalantis.ucrop.view.OverlayView;
import com.yalantis.ucrop.view.UCropView;

import java.lang.reflect.Field;

/**
 * UCrop activity that matches iOS TOCropViewController when aspect ratio is
 * locked: corners are draggable, the ratio is preserved, and the crop frame may
 * only shrink from its initial size — never expand.
 */
public class CmUCropActivity extends UCropActivity {

    /** Intent extra — set by {@link ImageCropperDelegate}. */
    public static final String EXTRA_FREE_STYLE_CROP_SHRINK_ONLY =
            "vn.hunghd.flutter.plugins.imagecropper.FreeStyleCropShrinkOnly";

    private RectF mMaxCropRect;
    private float mTargetAspectRatio;
    private boolean mAspectRatioLocked;
    private boolean mShrinkOnly;
    private int mMinCropSizePx;
    private Field mCornerIndexField;
    private int mActiveCorner = -1;

    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mShrinkOnly = getIntent().getBooleanExtra(EXTRA_FREE_STYLE_CROP_SHRINK_ONLY, false);
        if (!mShrinkOnly) {
            return;
        }
        final UCropView ucropView = findViewById(com.yalantis.ucrop.R.id.ucrop);
        if (ucropView == null) {
            return;
        }
        final OverlayView overlay = ucropView.getOverlayView();
        overlay.post(() -> waitForCropBoundsThenSetup(overlay, ucropView));
    }

    /**
     * Waits until uCrop has laid out a non-empty crop rect (happens after the
     * bitmap loads) before capturing the max bounds and attaching touch hooks.
     */
    private void waitForCropBoundsThenSetup(final OverlayView overlay, final UCropView ucropView) {
        final RectF cropRect = overlay.getCropViewRect();
        if (cropRect.width() < 1f || cropRect.height() < 1f) {
            overlay.post(() -> waitForCropBoundsThenSetup(overlay, ucropView));
            return;
        }
        setupShrinkOnlyMode(overlay, ucropView);
    }

    private void setupShrinkOnlyMode(final OverlayView overlay, final UCropView ucropView) {
        mMaxCropRect = new RectF(overlay.getCropViewRect());
        mTargetAspectRatio = mMaxCropRect.width() / mMaxCropRect.height();
        final float aspectRatioX = getIntent().getFloatExtra(UCrop.EXTRA_ASPECT_RATIO_X, -1f);
        final float aspectRatioY = getIntent().getFloatExtra(UCrop.EXTRA_ASPECT_RATIO_Y, -1f);
        mAspectRatioLocked = aspectRatioX > 0f && aspectRatioY > 0f;
        if (mAspectRatioLocked) {
            mTargetAspectRatio = aspectRatioX / aspectRatioY;
        }
        mMinCropSizePx = getResources().getDimensionPixelSize(
                com.yalantis.ucrop.R.dimen.ucrop_default_crop_rect_min_size);
        // Chain — do NOT replace UCropView's listener; it calls
        // overlay.setTargetAspectRatio() which draws the crop frame.
        final CropBoundsChangeListener existing =
                ucropView.getCropImageView().getCropBoundsChangeListener();
        ucropView.getCropImageView().setCropBoundsChangeListener(
                new CropBoundsChangeListener() {
                    @Override
                    public void onCropAspectRatioChanged(final float cropRatio) {
                        mTargetAspectRatio = cropRatio;
                        if (mMaxCropRect.width() < 1f || mMaxCropRect.height() < 1f) {
                            mMaxCropRect.set(overlay.getCropViewRect());
                        }
                        if (existing != null) {
                            existing.onCropAspectRatioChanged(cropRatio);
                        }
                    }
                });
        try {
            mCornerIndexField = OverlayView.class.getDeclaredField("mCurrentTouchCornerIndex");
            mCornerIndexField.setAccessible(true);
        } catch (NoSuchFieldException ignored) {
            mCornerIndexField = null;
        }
        final RectF cropRect = overlay.getCropViewRect();
        overlay.setOnTouchListener((view, event) -> handleOverlayTouch(overlay, cropRect, event));
    }

    private boolean handleOverlayTouch(
            final OverlayView overlay,
            final RectF cropRect,
            final MotionEvent event) {
        final int action = event.getAction() & MotionEvent.ACTION_MASK;
        if (action == MotionEvent.ACTION_DOWN) {
            final boolean handled = overlay.onTouchEvent(event);
            mActiveCorner = readActiveCorner(overlay);
            return handled;
        }
        if (action == MotionEvent.ACTION_UP || action == MotionEvent.ACTION_CANCEL) {
            final boolean handled = overlay.onTouchEvent(event);
            clampAndSync(overlay, cropRect, mActiveCorner);
            mActiveCorner = -1;
            return handled;
        }
        if (action == MotionEvent.ACTION_MOVE && mActiveCorner >= 0 && mActiveCorner <= 3) {
            float touchX = event.getX();
            float touchY = event.getY();
            if (mAspectRatioLocked) {
                final float[] adjusted = CropTouchMath.adjustCornerForAspectRatio(
                        mActiveCorner, mTargetAspectRatio, touchX, touchY, cropRect);
                touchX = adjusted[0];
                touchY = adjusted[1];
            }
            event.setLocation(touchX, touchY);
            overlay.onTouchEvent(event);
            clampAndSync(overlay, cropRect, mActiveCorner);
            return true;
        }
        return overlay.onTouchEvent(event);
    }

    private void clampAndSync(
            final OverlayView overlay,
            final RectF cropRect,
            final int corner) {
        final RectF crop = overlay.getCropViewRect();
        CropTouchMath.clampCropRectInsideMax(
                crop,
                mMaxCropRect,
                corner,
                mTargetAspectRatio,
                mAspectRatioLocked,
                mMinCropSizePx);
        cropRect.set(crop);
        syncOverlay(overlay);
    }

    private void syncOverlay(final OverlayView overlay) {
        overlay.postInvalidate();
        final OverlayViewChangeListener listener = overlay.getOverlayViewChangeListener();
        if (listener != null) {
            listener.onCropRectUpdated(overlay.getCropViewRect());
        }
    }

    private int readActiveCorner(final OverlayView overlay) {
        if (mCornerIndexField == null) {
            return -1;
        }
        try {
            return mCornerIndexField.getInt(overlay);
        } catch (IllegalAccessException ignored) {
            return -1;
        }
    }
}
