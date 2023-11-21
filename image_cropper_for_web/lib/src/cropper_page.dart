import 'package:flutter/material.dart';

import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

class CropperPage extends StatelessWidget {
  final Widget cropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle) rotate;
  final double cropperContainerWidth;
  final double cropperContainerHeight;
  final WebTranslations translations;

  const CropperPage({
    Key? key,
    required this.cropper,
    required this.crop,
    required this.rotate,
    required this.cropperContainerWidth,
    required this.cropperContainerHeight,
    required this.translations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.title),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await crop();
              Navigator.of(context).pop(result);
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: cropperContainerWidth,
              height: cropperContainerHeight,
              child: cropper,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      rotate(RotationAngle.counterClockwise90);
                    },
                    tooltip: translations.rotateLeftTooltip,
                    icon: const Icon(Icons.rotate_90_degrees_ccw_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      rotate(RotationAngle.clockwise90);
                    },
                    tooltip: translations.rotateRightTooltip,
                    icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
