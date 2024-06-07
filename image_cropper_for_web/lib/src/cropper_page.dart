import 'package:flutter/material.dart';

import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

import 'cropper_actionbar.dart';

class CropperPage extends StatelessWidget {
  final Widget cropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle) rotate;
  final void Function(num) scale;
  final double cropperContainerWidth;
  final double cropperContainerHeight;
  final WebTranslations translations;
  final WebThemeData? themeData;

  const CropperPage({
    Key? key,
    required this.cropper,
    required this.crop,
    required this.rotate,
    required this.scale,
    required this.cropperContainerWidth,
    required this.cropperContainerHeight,
    required this.translations,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.title),
        leading: themeData?.backIcon != null
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(themeData!.backIcon!),
              )
            : null,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await crop();
              Navigator.of(context).pop(result);
            },
            icon: Icon(themeData?.doneIcon ?? Icons.done),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: cropperContainerWidth,
                height: cropperContainerHeight,
                child: ClipRect(child: cropper),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 48.0,
              vertical: 24.0,
            ),
            child: CropperActionBar(
              onRotate: (angle) {
                rotate(angle);
              },
              onScale: (value) {
                scale(value);
              },
              translations: translations,
              themeData: themeData,
            ),
          ),
        ],
      ),
    );
  }
}
