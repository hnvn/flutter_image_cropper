import 'package:flutter/material.dart';

class CropperDialog extends StatelessWidget {
  final Widget cropper;
  final Future<String?> Function() crop;
  final double cropperContainerWidth;
  final double cropperContainerHeight;

  const CropperDialog({
    Key? key,
    required this.cropper,
    required this.crop,
    required this.cropperContainerWidth,
    required this.cropperContainerHeight,
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
              child: Center(
                  child: SizedBox(
                width: cropperContainerWidth,
                height: cropperContainerHeight,
                child: cropper,
              )),
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
            'Crop Image',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return ButtonBar(
      buttonPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: OutlinedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
          child: const Text('Cancel'),
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
          child: const Text('Crop'),
        ),
      ],
    );
  }
}
