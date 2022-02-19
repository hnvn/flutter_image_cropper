// Copyright 2013, the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

///
/// A set of preset values can be used to setup the menu of crop aspect ratio
/// options in the cropper view.
///
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

///
/// Crop style options. There're two supported styles, rectangle and circle.
/// These style will changes the shape of crop bounds, rectangle or circle bounds.
///
enum CropStyle { rectangle, circle }

///
/// Supported image compression formats
///
enum ImageCompressFormat { jpg, png }

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

String aspectRatioPresetName(CropAspectRatioPreset? preset) {
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
      return 'original';
  }
}

String cropStyleName(CropStyle style) {
  switch (style) {
    case CropStyle.rectangle:
      return 'rectangle';
    case CropStyle.circle:
      return 'circle';
    default:
      return 'rectangle';
  }
}

String compressFormatName(ImageCompressFormat format) {
  switch (format) {
    case ImageCompressFormat.jpg:
      return 'jpg';
    case ImageCompressFormat.png:
      return 'png';
    default:
      return 'jpg';
  }
}
