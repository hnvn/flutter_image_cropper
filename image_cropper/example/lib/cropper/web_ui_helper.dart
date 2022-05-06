import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_for_web/image_cropper_for_web.dart';

List<PlatformUiSettings>? buildUiSettings(BuildContext context) {
  return [
    WebUiSettings(
      context: context,
      presentStyle: CropperPresentStyle.dialog,
      boundary: Boundary(
        width: 520,
        height: 520,
      ),
      viewPort: ViewPort(width: 480, height: 480, type: 'circle'),
      enableExif: true,
      enableZoom: true,
      showZoomer: true,
    ),
  ];
}
