import 'package:flutter/material.dart';

import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

import 'cropper_actionbar.dart';

class CropperPage extends StatefulWidget {
  final Widget cropper;
  final Function() initCropper;
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
    required this.initCropper,
    required this.crop,
    required this.rotate,
    required this.scale,
    required this.cropperContainerWidth,
    required this.cropperContainerHeight,
    required this.translations,
    this.themeData,
  }) : super(key: key);

  @override
  State<CropperPage> createState() => _CropperPageState();
}

class _CropperPageState extends State<CropperPage> {
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    widget.initCropper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.translations.title),
        leading: widget.themeData?.backIcon != null
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(widget.themeData!.backIcon!),
              )
            : null,
        actions: [
          if (_processing)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            )
          else
            IconButton(
              onPressed: () => _doCrop(),
              icon: Icon(widget.themeData?.doneIcon ?? Icons.done),
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
                width: widget.cropperContainerWidth,
                height: widget.cropperContainerHeight,
                child: ClipRect(child: widget.cropper),
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
                widget.rotate(angle);
              },
              onScale: (value) {
                widget.scale(value);
              },
              translations: widget.translations,
              themeData: widget.themeData,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _doCrop() async {
    if (_processing) return;
    setState(() {
      _processing = true;
    });
    try {
      final result = await widget.crop();
      Navigator.of(context).pop(result);
      return;
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _processing = false;
    });
  }
}
