import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';

import 'package:flutter/services.dart';

class ImageCropper {
  static const MethodChannel _channel =
      const MethodChannel('plugins.hunghd.vn/image_cropper');

  static Future<File> cropImage({
      @required String sourcePath,
      double ratioX,
      double ratioY,
      int maxWidth,
      int maxHeight
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
          }
        );
    return resultPath == null ? null : new File(resultPath);
  }
}
