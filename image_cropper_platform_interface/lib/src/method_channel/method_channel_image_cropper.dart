// Copyright 2013, the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/services.dart';

import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

const MethodChannel _channel = MethodChannel('plugins.hunghd.vn/image_cropper');

/// An implementation of [ImageCropperPlatform] that uses method channels.
class MethodChannelImageCropper extends ImageCropperPlatform {
  /// The MethodChannel that is being used by this implementation of the plugin.
  MethodChannel get channel => _channel;

  ///
  /// Launch cropper UI for an image.
  ///
  ///
  /// **parameters:**
  ///
  /// * sourcePath: the absolute path of an image file.
  ///
  /// * maxWidth: maximum cropped image width.
  ///
  /// * maxHeight: maximum cropped image height.
  ///
  /// * aspectRatio: controls the aspect ratio of crop bounds. If this values is set,
  /// the cropper is locked and user can't change the aspect ratio of crop bounds.
  ///
  /// * compressFormat: the format of result image, png or jpg (default is [ImageCompressFormat.jpg])
  ///
  /// * compressQuality: the value [0 - 100] to control the quality of image compression
  ///
  /// * uiSettings: controls UI customization on specific platform (android, ios, web,...)
  ///
  /// **return:**
  ///
  /// A result file of the cropped image.
  ///
  ///
  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    assert(await File(sourcePath).exists());
    assert(maxWidth == null || maxWidth > 0);
    assert(maxHeight == null || maxHeight > 0);
    assert(compressQuality >= 0 && compressQuality <= 100);

    final arguments = <String, dynamic>{
      'source_path': sourcePath,
      'max_width': maxWidth,
      'max_height': maxHeight,
      'ratio_x': aspectRatio?.ratioX,
      'ratio_y': aspectRatio?.ratioY,
      'compress_format': compressFormat.name,
      'compress_quality': compressQuality,
    };

    if (uiSettings != null) {
      for (final settings in uiSettings) {
        arguments.addAll(settings.toMap());
      }
    }

    final String? resultPath =
        await _channel.invokeMethod('cropImage', arguments);
    return resultPath == null ? null : CroppedFile(resultPath);
  }

  ///
  /// Retrieve cropped image lost due to activity termination (Android only).
  /// This method works similarly to [retrieveLostData] method from [image_picker]
  /// library. Unlike [retrieveLostData], does not throw an error on other platforms,
  /// but returns null result.
  ///
  /// [recoverImage] as (well as [retrieveLostData]) will return value on any
  /// call after a successful [cropImage], so you can potentially get unexpected
  /// result when using [ImageCropper] in different layout. Recommended usage comes down to
  /// this:
  ///
  /// ```dart
  /// void crop() async {
  ///   final cropper = ImageCropper();
  ///   final croppedFile = await cropper.cropImage(/* your parameters */);
  ///   // At this point we know that the main activity did survive and we can
  ///   // discard the cached value
  ///   await cropper.recoverImage();
  ///   // process croppedFile value
  /// }
  ///
  /// @override
  /// void initState() {
  ///   _getLostData();
  ///   super.initState();
  /// }
  ///
  /// void _getLostData() async {
  ///   final recoveredCroppedImage = await ImageCropper().recoverImage();
  ///   if (recoveredCroppedImage != null) {
  ///      // process recoveredCroppedImage value
  ///   }
  /// }
  /// ```
  ///
  /// **return:**
  ///
  /// A result file of the cropped image.
  ///
  /// See also:
  /// * [Android Activity Lifecycle](https://developer.android.com/reference/android/app/Activity.html)
  ///
  ///
  @override
  Future<CroppedFile?> recoverImage() async {
    if (!Platform.isAndroid) {
      return null;
    }
    final String? resultPath = await _channel.invokeMethod('recoverImage');
    return resultPath == null ? null : CroppedFile(resultPath);
  }
}
