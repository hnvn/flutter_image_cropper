package vn.hunghd.flutter.plugins.imagecropper;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import androidx.preference.PreferenceManager;

import com.yalantis.ucrop.UCrop;
import com.yalantis.ucrop.model.AspectRatio;
import com.yalantis.ucrop.view.CropImageView;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class ImageCropperDelegate implements PluginRegistry.ActivityResultListener {
    static final String FILENAME_CACHE_KEY = "imagecropper.FILENAME_CACHE_KEY";

    private final Activity activity;
    private final SharedPreferences preferences;
    private final FileUtils fileUtils;
    private MethodChannel.Result pendingResult;

    public ImageCropperDelegate(Activity activity) {
        this.activity = activity;
        preferences = PreferenceManager.getDefaultSharedPreferences(activity.getApplicationContext());
        fileUtils = new FileUtils();
    }

    public void startCrop(MethodCall call, MethodChannel.Result result) {
        String sourcePath = call.argument("source_path");
        Integer maxWidth = call.argument("max_width");
        Integer maxHeight = call.argument("max_height");
        Double ratioX = call.argument("ratio_x");
        Double ratioY = call.argument("ratio_y");
        String compressFormat = call.argument("compress_format");
        Integer compressQuality = call.argument("compress_quality");
        ArrayList<Map<?, ?>> aspectRatioPresets = call.argument("android.aspect_ratio_presets");
        String cropStyle = call.argument("android.crop_style");
        String initAspectRatio = call.argument("android.init_aspect_ratio");

        pendingResult = result;

        File outputDir = activity.getCacheDir();
        File outputFile;
        if ("png".equals(compressFormat)) {
            outputFile = new File(outputDir, "image_cropper_" + (new Date()).getTime() + ".png");
        } else {
            outputFile = new File(outputDir, "image_cropper_" + (new Date()).getTime() + ".jpg");
        }
        Uri sourceUri = Uri.fromFile(new File(sourcePath));
        Uri destinationUri = Uri.fromFile(outputFile);

        UCrop.Options options = new UCrop.Options();
        // uCrop.withMaxResultSize(1000, 1000);
        options.setCompressionFormat("png".equals(compressFormat) ? Bitmap.CompressFormat.PNG : Bitmap.CompressFormat.JPEG);
        options.setCompressionQuality(compressQuality != null ? compressQuality : 90);
        options.setMaxBitmapSize(10000);

        // UI customization settings
        if ("circle".equals(cropStyle)) {
            options.setCircleDimmedLayer(true);
        }
        setupUiCustomizedOptions(options, call);

        if (aspectRatioPresets != null && initAspectRatio != null) {
            ArrayList<AspectRatio> aspectRatioList = new ArrayList<>();
            int defaultIndex = 0;
            for (int i = 0; i < aspectRatioPresets.size(); i++) {
                Map<?, ?> preset = aspectRatioPresets.get(i);
                if (preset != null) {
                    AspectRatio aspectRatio = parseAspectRatio(preset);
                    final String aspectRatioName = aspectRatio.getAspectRatioTitle();
                    aspectRatioList.add(aspectRatio);
                    if (initAspectRatio.equals(aspectRatioName)) {
                        defaultIndex = i;
                    }
                }
            }
            options.setAspectRatioOptions(defaultIndex, aspectRatioList.toArray(new AspectRatio[]{}));
        }

        UCrop cropper = UCrop.of(sourceUri, destinationUri).withOptions(options);
        if (maxWidth != null && maxHeight != null) {
            cropper.withMaxResultSize(maxWidth, maxHeight);
        }
        if (ratioX != null && ratioY != null) {
            cropper.withAspectRatio(ratioX.floatValue(), ratioY.floatValue());
        }

        activity.startActivityForResult(cropper.getIntent(activity), UCrop.REQUEST_CROP);
    }

    public void recoverImage(MethodCall call, MethodChannel.Result result) {
        result.success(getAndClearCachedImage());
    }

    private void cacheImage(String filePath) {
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(FILENAME_CACHE_KEY, filePath);
        editor.apply();
    }

    private String getAndClearCachedImage() {
        if (preferences.contains(FILENAME_CACHE_KEY)) {
            String result = preferences.getString(FILENAME_CACHE_KEY, "");
            SharedPreferences.Editor editor = preferences.edit();
            editor.remove(FILENAME_CACHE_KEY);
            editor.apply();
            return result;
        }
        return null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == UCrop.REQUEST_CROP) {
            if (resultCode == RESULT_OK) {
                final Uri resultUri = UCrop.getOutput(data);
                final String imagePath = fileUtils.getPathFromUri(activity, resultUri);
                cacheImage(imagePath);
                finishWithSuccess(imagePath);
                return true;
            } else if (resultCode == UCrop.RESULT_ERROR) {
                final Throwable cropError = UCrop.getError(data);
                finishWithError("crop_error", cropError.getLocalizedMessage(), cropError);
                return true;
            } else if (pendingResult != null) {
                pendingResult.success(null);
                clearMethodCallAndResult();
                return true;
            }
        }
        return false;
    }

    private void finishWithSuccess(String imagePath) {
        if (pendingResult != null) {
            pendingResult.success(imagePath);
            clearMethodCallAndResult();
        }
    }

    private void finishWithError(String errorCode, String errorMessage, Throwable throwable) {
        if (pendingResult != null) {
            pendingResult.error(errorCode, errorMessage, throwable);
            clearMethodCallAndResult();
        }
    }

    private UCrop.Options setupUiCustomizedOptions(UCrop.Options options, MethodCall call) {
        String title = call.argument("android.toolbar_title");
        Integer toolbarColor = call.argument("android.toolbar_color");
        Integer statusBarColor = call.argument("android.statusbar_color");
        Integer toolbarWidgetColor = call.argument("android.toolbar_widget_color");
        Integer backgroundColor = call.argument("android.background_color");
        Integer activeControlsWidgetColor = call.argument("android.active_controls_widget_color");
        Integer dimmedLayerColor = call.argument("android.dimmed_layer_color");
        Integer cropFrameColor = call.argument("android.crop_frame_color");
        Integer cropGridColor = call.argument("android.crop_grid_color");
        Integer cropFrameStrokeWidth = call.argument("android.crop_frame_stroke_width");
        Integer cropGridRowCount = call.argument("android.crop_grid_row_count");
        Integer cropGridColumnCount = call.argument("android.crop_grid_column_count");
        Integer cropGridStrokeWidth = call.argument("android.crop_grid_stroke_width");
        Boolean showCropGrid = call.argument("android.show_crop_grid");
        Boolean lockAspectRatio = call.argument("android.lock_aspect_ratio");
        Boolean hideBottomControls = call.argument("android.hide_bottom_controls");

        if (title != null) {
            options.setToolbarTitle(title);
        }
        if (toolbarColor != null) {
            options.setToolbarColor(toolbarColor);
        }
        if (statusBarColor != null) {
            options.setStatusBarColor(statusBarColor);
        } else if (toolbarColor != null) {
            options.setStatusBarColor(darkenColor(toolbarColor));
        }
        if (toolbarWidgetColor != null) {
            options.setToolbarWidgetColor(toolbarWidgetColor);
        }
        if (backgroundColor != null) {
            options.setRootViewBackgroundColor(backgroundColor);
        }
        if (activeControlsWidgetColor != null) {
            options.setActiveControlsWidgetColor(activeControlsWidgetColor);
        }
        if (dimmedLayerColor != null) {
            options.setDimmedLayerColor(dimmedLayerColor);
        }
        if (cropFrameColor != null) {
            options.setCropFrameColor(cropFrameColor);
        }
        if (cropGridColor != null) {
            options.setCropGridColor(cropGridColor);
        }
        if (cropFrameStrokeWidth != null) {
            options.setCropFrameStrokeWidth(cropFrameStrokeWidth);
        }
        if (cropGridRowCount != null) {
            options.setCropGridRowCount(cropGridRowCount);
        }
        if (cropGridColumnCount != null) {
            options.setCropGridColumnCount(cropGridColumnCount);
        }
        if (cropGridStrokeWidth != null) {
            options.setCropGridStrokeWidth(cropGridStrokeWidth);
        }
        if (showCropGrid != null) {
            options.setShowCropGrid(showCropGrid);
        }
        if (lockAspectRatio != null) {
            options.setFreeStyleCropEnabled(!lockAspectRatio);
        }
        if (hideBottomControls != null) {
            options.setHideBottomControls(hideBottomControls);
        }

        return options;
    }


    private void clearMethodCallAndResult() {
        pendingResult = null;
    }

    private int darkenColor(int color) {
        float[] hsv = new float[3];
        Color.colorToHSV(color, hsv);
        hsv[2] *= 0.8f;
        return Color.HSVToColor(hsv);
    }

    private AspectRatio parseAspectRatio(Map<?, ?> preset) {
        final String name = preset.containsKey("name") ? preset.get("name").toString() : null;
        final Object data = preset.containsKey("data") ? preset.get("data") : null;
        final Integer ratioX = data instanceof Map ? Integer.parseInt(((Map<?, ?>) data).get("ratio_x").toString()) : null;
        final Integer ratioY = data instanceof Map ? Integer.parseInt(((Map<?, ?>) data).get("ratio_y").toString()) : null;

        if ("original".equals(name) || ratioX == null) {
            return new AspectRatio(activity.getString(com.yalantis.ucrop.R.string.ucrop_label_original),
                    CropImageView.SOURCE_IMAGE_ASPECT_RATIO, 1.0f);
        } else {
            return new AspectRatio(name, ratioX * 1.0f, ratioY * 1.0f);
        }

    }
}
