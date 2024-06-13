// Copyright 2013, the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

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
  /// It causes some configuration fields not working (maxWidth, maxHeight, aspectRatio,
  /// aspectRatioPresets) and [WebUiSettings] is required for Web.
  ///
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) {
    return platform.cropImage(
      sourcePath: sourcePath,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: aspectRatio,
      compressFormat: compressFormat,
      compressQuality: compressQuality,
      uiSettings: uiSettings,
    );
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
  Future<CroppedFile?> recoverImage() {
    return platform.recoverImage();
  }
}
