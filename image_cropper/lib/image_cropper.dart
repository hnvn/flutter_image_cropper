///
/// * author: Hung Duy Ha (hunghd)
/// * email: hunghd.yb@gmail.com
///
/// A plugin provides capability of manipulating an image including rotating
/// and cropping.
///
/// Note that: this plugin is based on different native libraries depending on
/// Android or iOS platform, so it shows different UI look and feel between
/// those platforms.
///

export 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart'
    show
        CropAspectRatioPresetData,
        CropAspectRatioPreset,
        CropStyle,
        ImageCompressFormat,
        CropAspectRatio,
        CroppedFile,
        PlatformUiSettings,
        WebTranslations,
        AndroidUiSettings,
        IOSUiSettings,
        CropperDialogBuilder,
        CropperRouteBuilder,
        CropperPresentStyle,
        WebUiSettings,
        CropperSize,
        WebDragMode,
        WebViewMode,
        RotationAngle;

export 'src/cropper.dart';
