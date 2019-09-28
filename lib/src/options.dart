import 'package:flutter/widgets.dart';
import 'utils.dart';

enum CropAspectRatioPreset {
  original,
  square,
  ratio3x2,
  ratio5x3,
  ratio4x3,
  ratio5x4,
  ratio7x5,
  ratio16x9
}

enum CropStyle { rectangle, circle }

class CropAspectRatio {
  final double ratioX;
  final double ratioY;

  const CropAspectRatio({@required this.ratioX, @required this.ratioY})
      : assert(
            ratioX != null && ratioY != null && ratioX > 0.0 && ratioY > 0.0);

  @override
  int get hashCode => ratioX.hashCode ^ ratioY.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is CropAspectRatio &&
          this.ratioX == other.ratioX &&
          this.ratioY == other.ratioY;
}

class AndroidUiSettings {
  final String toolbarTitle;

  final Color toolbarColor;
  final Color statusBarColor;
  final Color toolbarWidgetColor;
  final Color backgroundColor;
  final Color activeControlsWidgetColor;
  final Color activeWidgetColor;
  final Color dimmedLayerColor;
  final Color cropFrameColor;
  final Color cropGridColor;

  final int cropFrameStrokeWidth;
  final int cropGridRowCount;
  final int cropGridColumnCount;
  final int cropGridStrokeWidth;

  final bool showCropGrid;
  final bool lockAspectRatio;
  final bool hideBottomControls;

  final CropAspectRatioPreset initAspectRatio;

  const AndroidUiSettings(
      {this.toolbarTitle,
      this.toolbarColor,
      this.statusBarColor,
      this.toolbarWidgetColor,
      this.backgroundColor,
      this.activeControlsWidgetColor,
      this.activeWidgetColor,
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
      this.initAspectRatio});

  Map<String, dynamic> toMap() => {
        'android.toolbar_title': this.toolbarTitle,
        'android.toolbar_color': int32(this.toolbarColor?.value),
        'android.statusbar_color': int32(this.statusBarColor?.value),
        'android.toolbar_widget_color': int32(this.toolbarWidgetColor?.value),
        'android.background_color': int32(this.backgroundColor?.value),
        'android.active_controls_widget_color':
            int32(this.activeControlsWidgetColor?.value),
        'android.active_widget_color': int32(this.activeWidgetColor?.value),
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
        'android.init_aspect_ratio': aspectRatioPresetName(this.initAspectRatio),
      };
}

class IOSUiSettings {
  final double minimumAspectRatio;

  final bool showActivitySheetOnDone;
  final bool showCancelConfirmationDialog;
  final bool rotateClockwiseButtonHidden;
  final bool hidesNavigationBar;
  final bool rotateButtonsHidden;
  final bool resetButtonHidden;
  final bool aspectRatioPickerButtonHidden;
  final bool resetAspectRatioEnabled;
  final bool aspectRatioLockDimensionSwapEnabled;
  final bool aspectRatioLockEnabled;

  final String doneButtonTitle;
  final String cancelButtonTitle;

  const IOSUiSettings({
    this.minimumAspectRatio,
    this.showActivitySheetOnDone,
    this.showCancelConfirmationDialog,
    this.rotateClockwiseButtonHidden,
    this.hidesNavigationBar,
    this.rotateButtonsHidden,
    this.resetButtonHidden,
    this.aspectRatioPickerButtonHidden,
    this.resetAspectRatioEnabled,
    this.aspectRatioLockDimensionSwapEnabled,
    this.aspectRatioLockEnabled,
    this.doneButtonTitle,
    this.cancelButtonTitle
  });

  Map<String, dynamic> toMap() => {
    'ios.minimum_aspect_ratio': this.minimumAspectRatio,
    'ios.show_activity_sheet_on_done': this.showActivitySheetOnDone,
    'ios.show_cancel_confirmation_dialog': this.showCancelConfirmationDialog,
    'ios.rotate_clockwise_button_hidden': this.rotateClockwiseButtonHidden,
    'ios.hides_navigation_bar': this.hidesNavigationBar,
    'ios.rotate_button_hidden': this.rotateButtonsHidden,
    'ios.reset_button_hidden': this.resetButtonHidden,
    'ios.aspect_ratio_picker_button_hidden': this.aspectRatioPickerButtonHidden,
    'ios.reset_aspect_ratio_enabled': this.resetAspectRatioEnabled,
    'ios.aspect_ratio_lock_dimension_swap_enabled': this.aspectRatioLockDimensionSwapEnabled,
    'ios.aspect_ratio_lock_enabled': this.aspectRatioLockEnabled,
    'ios.done_button_title': this.doneButtonTitle,
    'ios.cancel_button_title': this.cancelButtonTitle,
  };
}

String aspectRatioPresetName(CropAspectRatioPreset preset) {
  switch (preset) {
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
    default:
      return null;
  }
}

String cropStyleName(CropStyle style) {
  switch (style) {
    case CropStyle.rectangle:
      return 'rectangle';
    case CropStyle.circle:
      return 'circle';
    default:
      return null;
  }
}