///
/// * author: Hung Duy Ha (hunghd)
/// * email: hunghd.yb@gmail.com
///
/// * contributors: Jay Graves (skabber)
///
/// A plugin provides capability of manipulating an image including rotating
/// and cropping.
///
/// Note that: this plugin is based on different native libraries depending on
/// Android or iOS platform, so it shows different UI look and feel between
/// those platforms.
///

import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

///
/// A convenient class wraps all api functions of **ImageCropper** plugin
///
class ImageCropper {
  static const MethodChannel _channel =
      const MethodChannel('plugins.hunghd.vn/image_cropper');

  ///
  /// Launch a UI that lets user manipulate a given image.
  ///
  /// **parameters:**
  ///
  /// * `sourcePath`: absolute path of an image file
  /// * `ratioX`, `ratioY`: `ratioX` is horizontal aspect ratio and `ratioY` is
  /// vertical aspect ratio. The proportion of `ratioX` over `ratioY` is used
  /// as an aspect ratio for crop bounds and the capability of changing this
  /// ratio on UI is disabled in this case
  /// * `maxWidth`: maximum cropped image width
  /// * `maxHeight`: maximum cropped image height
  /// * `toolbarTitle`: title of ActionBar of Activity in Android
  /// * `toolbarColor`: color of ActionBar of Activity in Android
  /// * `circleShape`: a parameter that controls the shape of crop frame, `true`
  /// value makes crop frame a circle shape, rectangle shape in otherwise. The
  /// default value is `false`
  ///
  /// **return:**
  ///
  /// A result file of the cropped image
  ///
  static Future<File> cropImage({
    @required String sourcePath,
    double ratioX,
    double ratioY,
    int maxWidth,
    int maxHeight,
    bool circleShape: false,
    bool controlWidgetVisibility: true,
    // customization for Android
    String toolbarTitle,
    Color toolbarColor,
    Color statusBarColor,
    Color toolbarWidgetColor,
    Color backgroundColor,
    Color controlWidgetColor,
  }) async {
    assert(sourcePath != null);

    if (maxWidth != null && maxWidth < 0) {
      throw new ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw new ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
    }

    final String resultPath =
        await _channel.invokeMethod('cropImage', <String, dynamic>{
      'source_path': sourcePath,
      'max_width': maxWidth,
      'max_height': maxHeight,
      'ratio_x': ratioX,
      'ratio_y': ratioY,
      'circle_shape': circleShape,
      'toolbar_title': toolbarTitle,
      'toolbar_color': toolbarColor?.value,
      'statusbar_color': statusBarColor?.value,
      'toolbar_widget_color': toolbarWidgetColor?.value,
      'action_background_color': backgroundColor?.value,
      'bottom_widget_color': controlWidgetColor?.value,
      'bottom_widget_visibility': !controlWidgetVisibility,
    });
    return resultPath == null ? null : new File(resultPath);
  }
}
