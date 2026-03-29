import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageCropper {
  static Future<CroppedFile?> cropImage({
    required String sourcePath,
    required BuildContext context,
    double? aspectRatio,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    bool lockAspectRatio = false,
    Color? toolbarColor,
    Color? statusBarColor,
    Color? toolbarWidgetColor,
  }) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: toolbarColor ?? Colors.deepOrange,
          toolbarWidgetColor: toolbarWidgetColor ?? Colors.white,
          statusBarColor: statusBarColor ?? Colors.deepOrange,
          activeControlsWidgetColor: Colors.deepOrange,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: lockAspectRatio,
          aspectRatioPresets: aspectRatioPresets ?? [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: aspectRatioPresets ?? [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(
            width: 520,
            height: 520,
          ),
        ),
      ],
    );

    // Show custom dialog with padding
    if (croppedFile != null) {
      return showDialog<CroppedFile>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: Container(
              color: toolbarColor ?? Colors.deepOrange,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Custom toolbar with padding
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    color: toolbarColor ?? Colors.deepOrange,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        'Preview',
                        style: TextStyle(
                          color: toolbarWidgetColor ?? Colors.white,
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: toolbarWidgetColor ?? Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            color: toolbarWidgetColor ?? Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(croppedFile);
                          },
                        ),
                      ],
                    ),
                  ),
                  // Preview the cropped image
                  Expanded(
                    child: Image.file(
                      File(croppedFile.path),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return croppedFile;
  }
}

// Custom aspect ratio preset
class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
} 