import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

void main() {
  group('CropAspectRatioPreset', () {
    test('original has no ratio data', () {
      expect(CropAspectRatioPreset.original.name, 'original');
      expect(CropAspectRatioPreset.original.data, isNull);
    });

    test('named presets expose the expected ratios', () {
      expect(CropAspectRatioPreset.square.name, 'square');
      expect(CropAspectRatioPreset.square.data, (1, 1));
      expect(CropAspectRatioPreset.ratio16x9.name, '16x9');
      expect(CropAspectRatioPreset.ratio16x9.data, (16, 9));
    });
  });

  group('CropAspectRatio', () {
    test('equality is value based', () {
      expect(
        const CropAspectRatio(ratioX: 4, ratioY: 3),
        const CropAspectRatio(ratioX: 4, ratioY: 3),
      );
      expect(
        const CropAspectRatio(ratioX: 4, ratioY: 3),
        isNot(const CropAspectRatio(ratioX: 3, ratioY: 4)),
      );
    });
  });

  group('AndroidUiSettings.toMap', () {
    test('serializes colors and flags with the android.* prefix', () {
      final map = AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: const Color(0xFFFF5722),
        lockAspectRatio: true,
        freeStyleCropEnabled: true,
        freeStyleCropShrinkOnly: true,
        hideBottomControls: false,
        cropStyle: CropStyle.circle,
        initAspectRatio: CropAspectRatioPreset.square,
      ).toMap();

      expect(map['android.toolbar_title'], 'Cropper');
      // Colors are serialized as signed 32-bit ints via the int32() helper.
      expect(map['android.toolbar_color'], 0xFFFF5722.toSigned(32));
      expect(map['android.lock_aspect_ratio'], true);
      expect(map['android.free_style_crop_enabled'], true);
      expect(map['android.free_style_crop_shrink_only'], true);
      expect(map['android.hide_bottom_controls'], false);
      expect(map['android.crop_style'], 'circle');
      expect(map['android.init_aspect_ratio'], 'square');
    });

    test('leaves optional fields null when unset', () {
      final map = AndroidUiSettings().toMap();

      expect(map['android.free_style_crop_enabled'], isNull);
      expect(map['android.lock_aspect_ratio'], isNull);
      expect(map['android.crop_style'], 'rectangle');
    });

    test('serializes aspect ratio presets as a list of maps', () {
      final map = AndroidUiSettings(
        aspectRatioPresets: const [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio16x9,
        ],
      ).toMap();

      final presets = map['android.aspect_ratio_presets'] as List;
      expect(presets, hasLength(2));
      expect(presets[0], {'name': 'original'});
      expect(presets[1], {
        'name': '16x9',
        'data': {'ratio_x': 16, 'ratio_y': 9},
      });
    });
  });

  group('IOSUiSettings.toMap', () {
    test('serializes flags with the ios.* prefix', () {
      final map = IOSUiSettings(
        title: 'Edit',
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
        rotateButtonsHidden: true,
        cropStyle: CropStyle.circle,
      ).toMap();

      expect(map['ios.title'], 'Edit');
      expect(map['ios.aspect_ratio_lock_enabled'], true);
      expect(map['ios.reset_aspect_ratio_enabled'], false);
      expect(map['ios.rotate_button_hidden'], true);
      expect(map['ios.crop_style'], 'circle');
    });
  });
}
