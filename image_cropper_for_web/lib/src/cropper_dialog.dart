import 'package:flutter/material.dart';
import 'package:image_cropper_for_web/src/cropper_actionbar.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

class CropperDialog extends StatefulWidget {
  final Widget cropper;
  final Function() initCropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle) rotate;
  final void Function(num) scale;
  final double cropperContainerWidth;
  final double cropperContainerHeight;
  final WebTranslations translations;
  final WebThemeData? themeData;

  const CropperDialog({
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
  State<CropperDialog> createState() => _CropperDialogState();
}

class _CropperDialogState extends State<CropperDialog> {
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    widget.initCropper();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: widget.cropperContainerWidth + 2 * 24.0,
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
            widget.translations.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.cropperContainerWidth,
          height: widget.cropperContainerHeight,
          child: ClipRect(
            child: widget.cropper,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
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
    );
  }

  Widget _footer(BuildContext context) {
    if (_processing) {
      return const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      );
    } else {
      return ButtonBar(
        buttonPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(widget.translations.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => _doCrop(),
            child: Text(widget.translations.cropButton),
          ),
        ],
      );
    }
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
