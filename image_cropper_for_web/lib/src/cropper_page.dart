import 'package:flutter/material.dart';

class CropperPage extends StatelessWidget {
  final Widget cropper;
  final Future<String?> Function() crop;
  final double cropperContainerWidth;
  final double cropperContainerHeight;

  const CropperPage({
    Key? key,
    required this.cropper,
    required this.crop,
    required this.cropperContainerWidth,
    required this.cropperContainerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
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
        child: SizedBox(
          width: cropperContainerWidth,
          height: cropperContainerHeight,
          child: cropper,
        ),
      ),
    );
  }
}
