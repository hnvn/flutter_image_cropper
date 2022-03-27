// Copyright 2013, the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

import 'settings.dart';

///
/// A convenient class wraps all api functions of **ImageCropper** plugin
///
class ImageCropper {
  static ImageCropperPlatform get platform => ImageCropperPlatform.instance;

  ///
  /// Launch cropper UI for an image.
  ///
  ///
  /// **parameters:**
  ///
  /// * sourcePath: the absolute path of an image file.
  ///
  /// * maxWidth: maximum cropped image width. Note: this field is ignored on Web.
  ///
  /// * maxHeight: maximum cropped image height. Note: this field is ignored on Web
  ///
  /// * aspectRatio: controls the aspect ratio of crop bounds. If this values is set,
  /// the cropper is locked and user can't change the aspect ratio of crop bounds.
  /// Note: this field is ignored on Web
  ///
  /// * aspectRatioPresets: controls the list of aspect ratios in the crop menu view.
  /// In Android, you can set the initialized aspect ratio when starting the cropper
  /// by setting the value of [AndroidUiSettings.initAspectRatio]. Default is a list of
  /// [CropAspectRatioPreset.original], [CropAspectRatioPreset.square],
  /// [CropAspectRatioPreset.ratio3x2], [CropAspectRatioPreset.ratio4x3] and
  /// [CropAspectRatioPreset.ratio16x9].
  /// Note: this field is ignored on Web
  ///
  /// * cropStyle: controls the style of crop bounds, it can be rectangle or
  /// circle style (default is [CropStyle.rectangle]).
  /// Note: on Web, this field can be overrided by [WebUiSettings.viewPort.type]
  ///
  /// * compressFormat: the format of result image, png or jpg (default is [ImageCompressFormat.jpg])
  ///
  /// * compressQuality: the value [0 - 100] to control the quality of image compression
  ///
  /// * uiSettings: controls UI customization on specific platform (android, ios, web,...)
  ///
  /// See:
  ///  * [AndroidUiSettings] controls UI customization for Android
  ///  * [IOSUiSettings] controls UI customization for iOS
  ///
  /// **return:**
  ///
  /// A result file of the cropped image.
  ///
  /// **Note:**
  ///
  /// * The result file is saved in NSTemporaryDirectory on iOS and application Cache directory
  /// on Android, so it can be lost later, you are responsible for storing it somewhere
  /// permanent (if needed).
  ///
  /// * The implementation on Web is much different compared to the implementation on mobile app.
  /// It causes some configuration fields not working for Web (maxWidth, maxHeight, aspectRatio,
  /// aspectRatioPresets) and [WebUiSettings] is required for Web.
  ///
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset> aspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    CropStyle cropStyle = CropStyle.rectangle,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) {
    return platform.cropImage(
      sourcePath: sourcePath,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: aspectRatio,
      aspectRatioPresets: aspectRatioPresets,
      cropStyle: cropStyle,
      compressFormat: compressFormat,
      compressQuality: compressQuality,
      uiSettings: uiSettings,
    );
  }
}
