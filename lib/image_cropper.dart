import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class ImageCropper {
  static const MethodChannel _channel =
      const MethodChannel('plugins.hunghd.vn/image_cropper');

  /// Loads the image from [sourcePath], represents it on an UI that lets users
  /// crop, rotate the image. If the [ratioX] and [ratioY] are set, it will force
  /// users to crop the image in fixed aspect ratio.
  static Future<File> cropImage({
      @required String sourcePath,
      double ratioX,
      double ratioY,
      int maxWidth,
      int maxHeight,
      String toolbarTitle,  // for only Android
      Color toolbarColor,     // for only Android
      Color statusBarColor,     // for only Android
      Color activeWidgetColor,     // for only Android
  }) async {
    assert(sourcePath != null);

    if (maxWidth != null && maxWidth < 0) {
      throw new ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw new ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
    }

    final String resultPath = await _channel.invokeMethod(
        'cropImage',
        <String, dynamic> {
          'source_path': sourcePath,
          'max_width': maxWidth,
          'max_height': maxHeight,
          'ratio_x': ratioX,
          'ratio_y': ratioY,
          'toolbar_title': toolbarTitle,
          'toolbar_color': toolbarColor?.value,
          'status_bar_color': statusBarColor?.value,
          'active_widget_color': activeWidgetColor?.value,
          }
        );
    return resultPath == null ? null : new File(resultPath);
  }
}
