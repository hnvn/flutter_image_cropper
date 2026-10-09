import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:image_cropper_platform_interface/src/method_channel/method_channel_image_cropper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.hunghd.vn/image_cropper');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late MethodChannelImageCropper cropper;
  late List<MethodCall> log;
  late File sourceFile;

  setUp(() async {
    cropper = MethodChannelImageCropper();
    log = <MethodCall>[];
    sourceFile = File(
      '${Directory.systemTemp.path}/image_cropper_test_source.png',
    )..writeAsBytesSync(<int>[0, 1, 2, 3]);
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    if (sourceFile.existsSync()) sourceFile.deleteSync();
  });

  void mockResult(Object? result) {
    messenger.setMockMethodCallHandler(channel, (call) async {
      log.add(call);
      return result;
    });
  }

  group('cropImage', () {
    test('forwards arguments to the method channel', () async {
      mockResult('/tmp/cropped.png');

      await cropper.cropImage(
        sourcePath: sourceFile.path,
        maxWidth: 100,
        maxHeight: 200,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
        compressFormat: ImageCompressFormat.png,
        compressQuality: 80,
      );

      expect(log, hasLength(1));
      final call = log.single;
      expect(call.method, 'cropImage');
      final args = call.arguments as Map;
      expect(args['source_path'], sourceFile.path);
      expect(args['max_width'], 100);
      expect(args['max_height'], 200);
      expect(args['ratio_x'], 4.0);
      expect(args['ratio_y'], 3.0);
      expect(args['compress_format'], 'png');
      expect(args['compress_quality'], 80);
    });

    test('merges uiSettings into the arguments', () async {
      mockResult('/tmp/cropped.jpg');

      await cropper.cropImage(
        sourcePath: sourceFile.path,
        uiSettings: [AndroidUiSettings(toolbarTitle: 'Cropper')],
      );

      final args = log.single.arguments as Map;
      expect(args['android.toolbar_title'], 'Cropper');
    });

    test('wraps a non-null result path in a CroppedFile', () async {
      mockResult('/tmp/cropped.png');

      final result = await cropper.cropImage(sourcePath: sourceFile.path);

      expect(result, isNotNull);
      expect(result!.path, '/tmp/cropped.png');
    });

    test('returns null when the platform returns null', () async {
      mockResult(null);

      final result = await cropper.cropImage(sourcePath: sourceFile.path);

      expect(result, isNull);
    });
  });

  group('recoverImage', () {
    test('invokes recoverImage on Android', () async {
      mockResult('/tmp/recovered.png');

      final result = await cropper.recoverImage();

      if (Platform.isAndroid) {
        expect(log.single.method, 'recoverImage');
        expect(result?.path, '/tmp/recovered.png');
      } else {
        expect(log, isEmpty);
        expect(result, isNull);
      }
    });
  });
}
