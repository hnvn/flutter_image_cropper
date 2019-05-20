package vn.hunghd.flutter.plugins.imagecropper;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;

import com.yalantis.ucrop.UCrop;

import java.io.File;
import java.util.Date;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

public class ImageCropperDelegate implements PluginRegistry.ActivityResultListener {
    private final Activity activity;
    private MethodChannel.Result pendingResult;
    private MethodCall methodCall;
    private FileUtils fileUtils;

    public ImageCropperDelegate(Activity activity) {
        this.activity = activity;
        fileUtils = new FileUtils();
    }

    public void startCrop(MethodCall call, MethodChannel.Result result) {
        String sourcePath = call.argument("source_path");
        Integer maxWidth = call.argument("max_width");
        Integer maxHeight = call.argument("max_height");
        Double ratioX = call.argument("ratio_x");
        Double ratioY = call.argument("ratio_y");
        Boolean circleShape = call.argument("circle_shape");
        String title = call.argument("toolbar_title");
        Long toolbarColor = call.argument("toolbar_color");
        Long statusBarColor = call.argument("statusbar_color");
        Long toolbarWidgetColor = call.argument("toolbar_widget_color");
        Long actionBackgroundColor = call.argument("action_background_color");
        Long actionActiveColor = call.argument("action_active_color");
        Long bottomWidgetColor = call.argument("bottom_widget_color");
        Boolean bottomWidgetVisibility = call.argument("bottom_widget_visibility");
        methodCall = call;
        pendingResult = result;

        File outputDir = activity.getCacheDir();
        File outputFile = new File(outputDir, "image_cropper_" + (new Date()).getTime() + ".jpg");

        Uri sourceUri = Uri.fromFile(new File(sourcePath));
        Uri destinationUri = Uri.fromFile(outputFile);
        UCrop.Options options = new UCrop.Options();
        options.setCompressionFormat(Bitmap.CompressFormat.JPEG);
        if (circleShape!=null) {
            options.setCircleDimmedLayer(circleShape);
        }else {
            options.setCircleDimmedLayer(true);
        }
        options.setCompressionQuality(90);
        if (title != null) {
            options.setToolbarTitle(title);
        }
        if (toolbarColor != null) {
            int intColor = toolbarColor.intValue();
            options.setToolbarColor(intColor);
        }
        if (statusBarColor != null) {
            int intColor = statusBarColor.intValue();
            options.setStatusBarColor(intColor);
        } else if (toolbarColor != null) {
            int intColor = toolbarColor.intValue();
            options.setStatusBarColor(darkenColor(intColor));
        }
        if (toolbarWidgetColor != null) {
            int intColor = toolbarWidgetColor.intValue();
            options.setToolbarWidgetColor(intColor);
        }
        if (actionBackgroundColor != null) {
            int intColor = actionBackgroundColor.intValue();
            options.setRootViewBackgroundColor(intColor);
        }
        if (actionActiveColor != null) {
            int intColor = actionActiveColor.intValue();
            options.setActiveControlsWidgetColor(intColor);
        }
        if (bottomWidgetColor != null) {
            int intColor = bottomWidgetColor.intValue();
            options.setBottomWidgetBackground(intColor);
        }
        if (bottomWidgetVisibility != null) {
            options.setHideBottomControls(bottomWidgetVisibility);
        }else {
            options.setHideBottomControls(false);
        }

        UCrop cropper = UCrop.of(sourceUri, destinationUri).withOptions(options);
        if (maxWidth != null && maxHeight != null) {
            cropper.withMaxResultSize(maxWidth, maxHeight);
        }
        if (ratioX != null && ratioY != null) {
            cropper.withAspectRatio(ratioX.floatValue(), ratioY.floatValue());
        }

        cropper.start(activity);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == UCrop.REQUEST_CROP) {
            if (resultCode == RESULT_OK) {
                final Uri resultUri = UCrop.getOutput(data);
                finishWithSuccess(fileUtils.getPathFromUri(activity, resultUri));
                return true;
            } else if (resultCode == UCrop.RESULT_ERROR) {
                final Throwable cropError = UCrop.getError(data);
                finishWithError("crop_error", cropError.getLocalizedMessage(), cropError);
                return true;
            } else {
                pendingResult.success(null);
                clearMethodCallAndResult();
                return true;
            }
        }
        return false;
    }

    private void finishWithSuccess(String imagePath) {
        pendingResult.success(imagePath);
        clearMethodCallAndResult();
    }

    private void finishWithError(String errorCode, String errorMessage, Throwable throwable) {
        pendingResult.error(errorCode, errorMessage, throwable);
        clearMethodCallAndResult();
    }


    private void clearMethodCallAndResult() {
        methodCall = null;
        pendingResult = null;
    }

    private int darkenColor(int color) {
        float[] hsv = new float[3];
        Color.colorToHSV(color, hsv);
        hsv[2] *= 0.8f;
        return Color.HSVToColor(hsv);
    }
}
