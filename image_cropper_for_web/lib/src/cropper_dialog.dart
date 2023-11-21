import 'package:flutter/material.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

class CropperDialog extends StatelessWidget {
  final Widget cropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle) rotate;
  final double cropperContainerWidth;
  final double cropperContainerHeight;
  final WebTranslations translations;

  const CropperDialog({
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
    return Container(
      width: cropperContainerWidth + 2 * 24.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _header(context),
            const Divider(height: 1.0, thickness: 1.0),
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                left: 24.0,
                right: 24.0,
                bottom: 8.0,
              ),
              child: _body(context),
            ),
            const Divider(height: 1.0, thickness: 1.0),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translations.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: SizedBox(
            width: cropperContainerWidth,
            height: cropperContainerHeight,
            child: cropper,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 5.0),
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
    );
  }

  Widget _footer(BuildContext context) {
    return ButtonBar(
      buttonPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
          child: Text(translations.cancelButton),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await crop();
            Navigator.of(context).pop(result);
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
          child: Text(translations.cropButton),
        ),
      ],
    );
  }
}
