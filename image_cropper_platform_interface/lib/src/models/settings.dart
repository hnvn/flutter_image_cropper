import 'package:flutter/material.dart';

import '../utils.dart';

///
/// A set of preset values can be used to setup the menu of crop aspect ratio
/// options in the cropper view.
///

abstract class CropAspectRatioPresetData {
  /// name should be unique
  String get name;

  (int ratioX, int ratioY)? get data;
}

enum CropAspectRatioPreset implements CropAspectRatioPresetData {
  original,
  square,
  ratio3x2,
  ratio5x3,
  ratio4x3,
  ratio5x4,
  ratio7x5,
  ratio16x9;

  @override
  String get name {
    switch (this) {
      case CropAspectRatioPreset.original:
        return 'original';
      case CropAspectRatioPreset.square:
        return 'square';
      case CropAspectRatioPreset.ratio3x2:
        return '3x2';
      case CropAspectRatioPreset.ratio4x3:
        return '4x3';
      case CropAspectRatioPreset.ratio5x3:
        return '5x3';
      case CropAspectRatioPreset.ratio5x4:
        return '5x4';
      case CropAspectRatioPreset.ratio7x5:
        return '7x5';
      case CropAspectRatioPreset.ratio16x9:
        return '16x9';
    }
  }

  @override
  (int ratioX, int ratioY)? get data {
    switch (this) {
      case CropAspectRatioPreset.original:
        return null;
      case CropAspectRatioPreset.square:
        return (1, 1);
      case CropAspectRatioPreset.ratio3x2:
        return (3, 2);
      case CropAspectRatioPreset.ratio4x3:
        return (4, 3);
      case CropAspectRatioPreset.ratio5x3:
        return (5, 3);
      case CropAspectRatioPreset.ratio5x4:
        return (5, 4);
      case CropAspectRatioPreset.ratio7x5:
        return (7, 5);
      case CropAspectRatioPreset.ratio16x9:
        return (16, 9);
    }
  }
}

///
/// Crop style options. There're two supported styles, rectangle and circle.
/// These style will changes the shape of crop bounds, rectangle or circle bounds.
///
enum CropStyle {
  rectangle,
  circle;

  String get name {
    switch (this) {
      case CropStyle.rectangle:
        return 'rectangle';
      case CropStyle.circle:
        return 'circle';
    }
  }
}

///
/// Supported image compression formats
///
enum ImageCompressFormat {
  jpg,
  png;

  String get name {
    switch (this) {
      case ImageCompressFormat.jpg:
        return 'jpg';
      case ImageCompressFormat.png:
        return 'png';
    }
  }
}

class CropAspectRatio {
  final double ratioX;
  final double ratioY;

  const CropAspectRatio({required this.ratioX, required this.ratioY})
      : assert(ratioX > 0.0 && ratioY > 0.0);

  @override
  int get hashCode => ratioX.hashCode ^ ratioY.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is CropAspectRatio &&
          this.ratioX == other.ratioX &&
          this.ratioY == other.ratioY;
}

///
/// An abstract class encapsulates UI attributes for customization
///
abstract class PlatformUiSettings {
  Map<String, dynamic> toMap();
}

///
/// A helper class provides properties that can be used to customize the cropper
/// view on Android.
///
/// The properties is mapped to fields of `Ucrop.Options` class in Ucrop library.
///
/// See: <https://github.com/Yalantis/uCrop/blob/master/ucrop/src/main/java/com/yalantis/ucrop/UCrop.java#L260>
///
class AndroidUiSettings extends PlatformUiSettings {
  /// desired text for Toolbar title
  final String? toolbarTitle;

  /// desired color of the Toolbar
  final Color? toolbarColor;

  /// desired color of status
  final Color? statusBarColor;

  /// desired color of Toolbar text and buttons (default is black)
  final Color? toolbarWidgetColor;

  /// desired background color that should be applied to the root view
  final Color? backgroundColor;

  /// desired resolved color of the active and selected widget and progress wheel middle line (default is darker orange)
  final Color? activeControlsWidgetColor;

  /// desired color of dimmed area around the crop bounds
  final Color? dimmedLayerColor;

  /// desired color of crop frame
  final Color? cropFrameColor;

  /// desired color of crop grid/guidelines
  final Color? cropGridColor;

  /// desired width of crop frame line in pixels
  final int? cropFrameStrokeWidth;

  /// crop grid rows count
  final int? cropGridRowCount;

  /// crop grid columns count
  final int? cropGridColumnCount;

  /// desired width of crop grid lines in pixels
  final int? cropGridStrokeWidth;

  /// set to true if you want to see a crop grid/guidelines on top of an image
  final bool? showCropGrid;

  /// set to true if you want to lock the aspect ratio of crop bounds with a fixed value
  /// (locked by default)
  final bool? lockAspectRatio;

  /// set to true to hide the bottom controls (shown by default)
  final bool? hideBottomControls;

  /// controls the style of crop bounds, it can be rectangle or
  /// circle style (default is [CropStyle.rectangle]).
  final CropStyle cropStyle;

  /// controls the list of aspect ratios in the crop menu view.
  final List<CropAspectRatioPresetData> aspectRatioPresets;

  /// desired aspect ratio is applied (from the list of given aspect ratio presets)
  /// when starting the cropper
  final CropAspectRatioPresetData? initAspectRatio;

  AndroidUiSettings({
    this.toolbarTitle,
    this.toolbarColor,
    this.statusBarColor,
    this.toolbarWidgetColor,
    this.backgroundColor,
    this.activeControlsWidgetColor,
    this.dimmedLayerColor,
    this.cropFrameColor,
    this.cropGridColor,
    this.cropFrameStrokeWidth,
    this.cropGridRowCount,
    this.cropGridColumnCount,
    this.cropGridStrokeWidth,
    this.showCropGrid,
    this.lockAspectRatio,
    this.hideBottomControls,
    this.initAspectRatio,
    this.cropStyle = CropStyle.rectangle,
    this.aspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
  });

  @override
  Map<String, dynamic> toMap() => {
        'android.toolbar_title': this.toolbarTitle,
        'android.toolbar_color': int32(this.toolbarColor?.value),
        'android.statusbar_color': int32(this.statusBarColor?.value),
        'android.toolbar_widget_color': int32(this.toolbarWidgetColor?.value),
        'android.background_color': int32(this.backgroundColor?.value),
        'android.active_controls_widget_color':
            int32(this.activeControlsWidgetColor?.value),
        'android.dimmed_layer_color': int32(this.dimmedLayerColor?.value),
        'android.crop_frame_color': int32(this.cropFrameColor?.value),
        'android.crop_grid_color': int32(this.cropGridColor?.value),
        'android.crop_frame_stroke_width': this.cropFrameStrokeWidth,
        'android.crop_grid_row_count': this.cropGridRowCount,
        'android.crop_grid_column_count': this.cropGridColumnCount,
        'android.crop_grid_stroke_width': this.cropGridStrokeWidth,
        'android.show_crop_grid': this.showCropGrid,
        'android.lock_aspect_ratio': this.lockAspectRatio,
        'android.hide_bottom_controls': this.hideBottomControls,
        'android.init_aspect_ratio': this.initAspectRatio?.name,
        'android.crop_style': this.cropStyle.name,
        'android.aspect_ratio_presets': aspectRatioPresets
            .map<Map<String, dynamic>>((item) => {
                  'name': item.name,
                  if (item.data != null)
                    'data': {
                      'ratio_x': item.data!.$1,
                      'ratio_y': item.data!.$2,
                    },
                })
            .toList(),
      };
}

///
/// A helper class provides properties that can be used to customize the cropper
/// view on iOS.
///
/// The properties is mapped to properties of `TOCropViewController` class in
/// TOCropViewController library.
///
/// See: <https://github.com/TimOliver/TOCropViewController/blob/master/Objective-C/TOCropViewController/TOCropViewController.h>
///
class IOSUiSettings extends PlatformUiSettings {
  /// The minimum croping aspect ratio. If set, user is prevented from setting
  /// cropping rectangle to lower aspect ratio than defined by the parameter.
  final double? minimumAspectRatio;

  /// The initial rect of cropping.
  final double? rectX;
  final double? rectY;
  final double? rectWidth;
  final double? rectHeight;

  /// If true, when the user hits 'Done', a UIActivityController will appear
  /// before the view controller ends.
  final bool? showActivitySheetOnDone;

  /// Shows a confirmation dialog when the user hits 'Cancel' and there are pending changes.
  /// (default is false)
  final bool showCancelConfirmationDialog;

  /// When disabled, an additional rotation button that rotates the canvas in
  /// 90-degree segments in a clockwise direction is shown in the toolbar.
  /// (default is false)
  final bool rotateClockwiseButtonHidden;

  /// If this controller is embedded in UINavigationController its navigation bar
  /// is hidden by default. Set this property to false to show the navigation bar.
  /// This must be set before this controller is presented.
  final bool? hidesNavigationBar;

  /// When enabled, hides the rotation button, as well as the alternative rotation
  /// button visible when `showClockwiseRotationButton` is set to YES.
  /// (default is false)
  final bool rotateButtonsHidden;

  /// When enabled, hides the 'Reset' button on the toolbar.
  /// (default is false)
  final bool resetButtonHidden;

  /// When enabled, hides the 'Aspect Ratio Picker' button on the toolbar.
  /// (default is false)
  final bool aspectRatioPickerButtonHidden;

  /// If true, tapping the reset button will also reset the aspect ratio back to the image
  /// default ratio. Otherwise, the reset will just zoom out to the current aspect ratio.
  ///
  /// If this is set to false, and `aspectRatioLockEnabled` is set to true, then the aspect ratio
  /// button will automatically be hidden from the toolbar.
  ///
  /// (default is true)
  final bool resetAspectRatioEnabled;

  /// If true, a custom aspect ratio is set, and the aspectRatioLockEnabled is set to true, the crop box
  /// will swap it's dimensions depending on portrait or landscape sized images.
  /// This value also controls whether the dimensions can swap when the image is rotated.
  ///
  /// (default is false)
  final bool aspectRatioLockDimensionSwapEnabled;

  /// If true, while it can still be resized, the crop box will be locked to its current aspect ratio.
  ///
  /// If this is set to true, and `resetAspectRatioEnabled` is set to false, then the aspect ratio
  /// button will automatically be hidden from the toolbar.
  ///
  /// (default is false)
  final bool aspectRatioLockEnabled;

  /// Title text that appears at the top of the view controller.
  final String? title;

  /// Title for the 'Done' button.
  /// Setting this will override the Default which is a localized string for "Done".
  final String? doneButtonTitle;

  /// Title for the 'Cancel' button.
  /// Setting this will override the Default which is a localized string for "Cancel".
  final String? cancelButtonTitle;

  /// controls the style of crop bounds, it can be rectangle or
  /// circle style (default is [CropStyle.rectangle]).
  final CropStyle cropStyle;

  /// controls the list of aspect ratios in the crop menu view.
  final List<CropAspectRatioPresetData> aspectRatioPresets;

  IOSUiSettings({
    this.minimumAspectRatio,
    this.rectX,
    this.rectY,
    this.rectWidth,
    this.rectHeight,
    this.showActivitySheetOnDone,
    this.showCancelConfirmationDialog = false,
    this.rotateClockwiseButtonHidden = false,
    this.hidesNavigationBar,
    this.rotateButtonsHidden = false,
    this.resetButtonHidden = false,
    this.aspectRatioPickerButtonHidden = false,
    this.resetAspectRatioEnabled = true,
    this.aspectRatioLockDimensionSwapEnabled = false,
    this.aspectRatioLockEnabled = false,
    this.title,
    this.doneButtonTitle,
    this.cancelButtonTitle,
    this.cropStyle = CropStyle.rectangle,
    this.aspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
  });

  @override
  Map<String, dynamic> toMap() => {
        'ios.minimum_aspect_ratio': this.minimumAspectRatio,
        'ios.rect_x': this.rectX,
        'ios.rect_y': this.rectY,
        'ios.rect_width': this.rectWidth,
        'ios.rect_height': this.rectHeight,
        'ios.show_activity_sheet_on_done': this.showActivitySheetOnDone,
        'ios.show_cancel_confirmation_dialog':
            this.showCancelConfirmationDialog,
        'ios.rotate_clockwise_button_hidden': this.rotateClockwiseButtonHidden,
        'ios.hides_navigation_bar': this.hidesNavigationBar,
        'ios.rotate_button_hidden': this.rotateButtonsHidden,
        'ios.reset_button_hidden': this.resetButtonHidden,
        'ios.aspect_ratio_picker_button_hidden':
            this.aspectRatioPickerButtonHidden,
        'ios.reset_aspect_ratio_enabled': this.resetAspectRatioEnabled,
        'ios.aspect_ratio_lock_dimension_swap_enabled':
            this.aspectRatioLockDimensionSwapEnabled,
        'ios.aspect_ratio_lock_enabled': this.aspectRatioLockEnabled,
        'ios.title': this.title,
        'ios.done_button_title': this.doneButtonTitle,
        'ios.cancel_button_title': this.cancelButtonTitle,
        'ios.crop_style': this.cropStyle.name,
        'ios.aspect_ratio_presets': aspectRatioPresets
            .map<Map<String, dynamic>>((item) => {
                  'name': item.name,
                  if (item.data != null)
                    'data': {
                      'ratio_x': item.data!.$1,
                      'ratio_y': item.data!.$2,
                    },
                })
            .toList(),
      };
}

typedef CropperDialogBuilder = Dialog Function(
  Widget cropper,
  Future<String?> Function() crop,
  void Function(RotationAngle) rotate,
);

typedef CropperRouteBuilder = PageRoute<String> Function(
  Widget cropper,
  Future<String?> Function() crop,
  void Function(RotationAngle) rotate,
);

enum CropperPresentStyle { dialog, page }

class CropperSize {
  const CropperSize({
    this.width,
    this.height,
  });

  final int? width;
  final int? height;
}

class WebUiSettings extends PlatformUiSettings {
  /// Display size of the cropper
  ///
  /// Default = { width: 500, height: 500 }
  final CropperSize? size;

  /// Define the view mode of the cropper.
  ///
  /// Options:
  ///  - 0: no restrictions
  ///  - 1: restrict the crop box not to exceed the size of the canvas.
  ///  - 2: restrict the minimum canvas size to fit within the container.
  ///       If the proportions of the canvas and the container differ,
  ///       the minimum canvas will be surrounded by extra space in one of the dimensions.
  ///  - 3: restrict the minimum canvas size to fill fit the container.
  ///       If the proportions of the canvas and the container are different,
  ///       the container will not be able to fit the whole canvas in one of the dimensions.
  ///
  /// Default = 0
  ///
  /// If you set viewMode to 0, the crop box can extend outside the canvas,
  /// while a value of 1, 2, or 3 will restrict the crop box to the size of the canvas.
  /// viewMode of 2 or 3 will additionally restrict the canvas to the container.
  /// There is no difference between 2 and 3 when the proportions of the canvas and the container are the same.
  final WebViewMode? viewwMode;

  /// Define the dragging mode of the cropper.
  ///
  /// Options:
  ///   - 'crop': create a new crop box
  ///   - 'move':  move the canvas
  ///   - 'none': do nothing
  ///
  /// Default = 'crop'
  final WebDragMode? dragMode;

  /// Define the initial aspect ratio of the crop box.
  /// By default, it is the same as the aspect ratio of the canvas (image wrapper).
  ///
  /// Note: Only available when the aspectRatio option is set to NaN.
  final num? initialAspectRatio;

  // /// Define the fixed aspect ratio of the crop box. By default, the crop box has a free ratio.
  // final num? aspectRatio;

  /// Check if the current image is a cross-origin image.
  ///
  /// If so, a crossOrigin attribute will be added to the cloned image element,
  /// and a timestamp parameter will be added to the src attribute to reload the source image to avoid browser cache error.
  ///
  /// Adding a crossOrigin attribute to the image element will stop adding a timestamp to the image URL
  /// and stop reloading the image. But the request (XMLHttpRequest) to read the image data for orientation checking
  /// will require a timestamp to bust the cache to avoid browser cache error.
  /// You can set the checkOrientation option to false to cancel this request.
  ///
  /// If the value of the image's crossOrigin attribute is "use-credentials",
  /// then the withCredentials attribute will set to true when read the image data by XMLHttpRequest.
  ///
  /// Default = true
  final bool? checkCrossOrigin;

  /// Check the current image's Exif Orientation information.
  /// Note that only a JPEG image may contain Exif Orientation information.
  ///
  /// Requires to set both the rotatable and scalable options to true at the same time.
  ///
  /// Note: Do not trust this all the time as some JPG images may have incorrect (non-standard) Orientation values
  ///
  /// Default = true
  ///
  final bool? checkOrientation;

  /// Show the black modal above the image and under the crop box.
  ///
  /// Default = true
  final bool? modal;

  /// Show the dashed lines above the crop box.
  ///
  /// Default = true
  final bool? guides;

  /// Show the center indicator above the crop box.
  ///
  /// Default = true
  final bool? center;

  /// Show the white modal above the crop box (highlight the crop box).
  ///
  /// Default = true
  final bool? highlight;

  /// Show the grid background of the container.
  ///
  /// Default = true
  final bool? background;

  /// Enable to move the image.
  ///
  /// Default = true
  final bool? movable;

  /// Enable to rotate the image.
  ///
  /// Default = true
  final bool? rotatable;

  /// Enable to scale the image.
  ///
  /// Default = true
  final bool? scalable;

  /// Enable to zoom the image.
  ///
  /// Default = true
  final bool? zoomable;

  /// Enable to zoom the image by dragging touch.
  ///
  /// Default = true
  final bool? zoomOnTouch;

  /// Enable to zoom the image by mouse wheeling.
  ///
  /// Default = true
  final bool? zoomOnWheel;

  /// Define zoom ratio when zooming the image by mouse wheeling.
  ///
  /// Default = 0.1
  final num? wheelZoomRatio;

  /// Enable to move the crop box by dragging.
  ///
  /// Default = true
  final bool? cropBoxMovable;

  /// Enable to resize the crop box by dragging.
  ///
  /// Default = true
  final bool? cropBoxResizable;

  /// Enable to toggle drag mode between "crop" and "move" when clicking twice on the cropper.
  ///
  /// Default = true
  final bool? toggleDragModeOnDblclick;

  /// The minimum width of the container.
  ///
  /// Default = 200
  final num? minContainerWidth;

  /// The minimum height of the container.
  ///
  /// Default = 100
  final num? minContainerHeight;

  /// The minimum width of the crop box.
  ///
  /// Note: This size is relative to the page, not the image.
  ///
  /// Default = 0
  final num? minCropBoxWidth;

  /// The minimum height of the crop box.
  ///
  /// Note: This size is relative to the page, not the image.
  ///
  /// Default = 0
  final num? minCropBoxHeight;

  /// Presentation style of cropper, either a dialog or a page (route)
  /// Default = dialog
  final CropperPresentStyle presentStyle;

  /// Current BuildContext
  /// The context is required to show cropper dialog or route
  final BuildContext context;

  /// Builder to customize the cropper [Dialog]
  final CropperDialogBuilder? customDialogBuilder;

  /// Builder to customize the cropper [PageRoute]
  final CropperRouteBuilder? customRouteBuilder;

  /// Barrier color for displayed [Dialog]
  final Color? barrierColor;

  /// Translations to display
  final WebTranslations? translations;

  WebUiSettings({
    required this.context,
    this.presentStyle = CropperPresentStyle.dialog,
    this.customDialogBuilder,
    this.customRouteBuilder,
    this.size,
    this.viewwMode,
    this.dragMode,
    this.initialAspectRatio,
    // this.aspectRatio,
    this.checkCrossOrigin,
    this.checkOrientation,
    this.modal,
    this.guides,
    this.center,
    this.highlight,
    this.background,
    this.movable,
    this.rotatable,
    this.scalable,
    this.zoomable,
    this.zoomOnTouch,
    this.zoomOnWheel,
    this.wheelZoomRatio,
    this.cropBoxMovable,
    this.cropBoxResizable,
    this.toggleDragModeOnDblclick,
    this.minContainerWidth,
    this.minContainerHeight,
    this.minCropBoxWidth,
    this.minCropBoxHeight,
    this.translations,
    this.barrierColor,
  });

  @override
  Map<String, dynamic> toMap() => {};
}

enum RotationAngle {
  clockwise90,
  clockwise180,
  clockwise270,
  counterClockwise90,
  counterClockwise180,
  counterClockwise270,
}

int rotationAngleToNumber(RotationAngle angle) {
  switch (angle) {
    case RotationAngle.clockwise90:
      return 90;
    case RotationAngle.clockwise180:
      return 180;
    case RotationAngle.clockwise270:
      return 270;
    case RotationAngle.counterClockwise90:
      return -90;
    case RotationAngle.counterClockwise180:
      return -180;
    case RotationAngle.counterClockwise270:
      return -270;
  }
}

class WebTranslations {
  final String title;
  final String rotateLeftTooltip;
  final String rotateRightTooltip;
  final String cancelButton;
  final String cropButton;

  const WebTranslations({
    required this.title,
    required this.rotateLeftTooltip,
    required this.rotateRightTooltip,
    required this.cancelButton,
    required this.cropButton,
  });

  const WebTranslations.en()
      : title = 'Crop Image',
        rotateLeftTooltip = 'Rotate 90 degree counter-clockwise',
        rotateRightTooltip = 'Rotate 90 degree clockwise',
        cancelButton = 'Cancel',
        cropButton = 'Crop';
}

enum WebDragMode {
  crop,
  move,
  none,
}

String dragModeToString(WebDragMode mode) {
  switch (mode) {
    case WebDragMode.crop:
      return 'crop';
    case WebDragMode.move:
      return 'move';
    case WebDragMode.none:
      return 'none';
  }
}

enum WebViewMode {
  mode_0,
  mode_1,
  mode_2,
  mode_3,
}

int viewModeToNumber(WebViewMode mode) {
  switch (mode) {
    case WebViewMode.mode_0:
      return 0;
    case WebViewMode.mode_1:
      return 1;
    case WebViewMode.mode_2:
      return 2;
    case WebViewMode.mode_3:
      return 3;
  }
}
