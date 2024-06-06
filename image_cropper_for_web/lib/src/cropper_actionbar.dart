import 'package:flutter/material.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

class CropperActionBar extends StatefulWidget {
  final Function(RotationAngle) onRotate;
  final Function(num) onScale;
  final WebTranslations translations;
  final WebThemeData? themeData;

  const CropperActionBar({
    super.key,
    required this.onRotate,
    required this.onScale,
    required this.translations,
    this.themeData,
  });

  @override
  State<CropperActionBar> createState() => _CropperActionBarState();
}

class _CropperActionBarState extends State<CropperActionBar> {
  double _scaleValue = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            widget.onRotate(RotationAngle.counterClockwise90);
          },
          tooltip: widget.translations.rotateLeftTooltip,
          style: widget.themeData?.rotateIconColor != null
              ? IconButton.styleFrom(
                  foregroundColor: widget.themeData?.rotateIconColor,
                )
              : null,
          icon: Icon(
            widget.themeData?.rotateLeftIcon ??
                Icons.rotate_90_degrees_ccw_rounded,
          ),
        ),
        Expanded(
          child: Slider(
            value: _scaleValue,
            min: widget.themeData?.scaleSliderMinValue ?? 1.0,
            max: widget.themeData?.scaleSliderMaxValue ?? 3.0,
            divisions: widget.themeData?.scaleSliderDivisions,
            label: _scaleValue.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _scaleValue = value;
              });
              widget.onScale(value);
            },
          ),
        ),
        IconButton(
          onPressed: () {
            widget.onRotate(RotationAngle.clockwise90);
          },
          tooltip: widget.translations.rotateRightTooltip,
          style: widget.themeData?.rotateIconColor != null
              ? IconButton.styleFrom(
                  foregroundColor: widget.themeData?.rotateIconColor,
                )
              : null,
          icon: Icon(widget.themeData?.rotateRightIcon ??
              Icons.rotate_90_degrees_cw_outlined),
        )
      ],
    );
  }
}
