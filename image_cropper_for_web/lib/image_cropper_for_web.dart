library image_cropper_for_web;

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_cropper_for_web/src/cropper_dialog.dart';
import 'package:image_cropper_for_web/src/cropper_page.dart';
import 'package:image_cropper_for_web/src/settings.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

import 'src/croppie/croppie_dart.dart';

export 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart'
    show
        CropAspectRatioPreset,
        CropStyle,
        ImageCompressFormat,
        CropAspectRatio,
        CroppedFile;
export 'src/croppie/croppie_dart_base.dart' show Boundary, ViewPort;
export 'src/settings.dart';

/// The web implementation of [ImageCropperPlatform].
///
/// This class implements the `package:image_picker` functionality for the web.
class ImageCropperPlugin extends ImageCropperPlatform {
  /// Registers this class as the default instance of [ImageCropperPlatform].
  static void registerWith(Registrar registrar) {
    ImageCropperPlatform.instance = ImageCropperPlugin();
  }

  ///
  /// Launch cropper UI for an image.
  ///
  ///
  /// **parameters:**
  ///
  /// * sourcePath: the absolute path of an image file.
  ///
  /// * maxWidth: maximum cropped image width.
  ///
  /// * maxHeight: maximum cropped image height.
  ///
  /// * aspectRatio: controls the aspect ratio of crop bounds. If this values is set,
  /// the cropper is locked and user can't change the aspect ratio of crop bounds.
  ///
  /// * aspectRatioPresets: controls the list of aspect ratios in the crop menu view.
  /// In Android, you can set the initialized aspect ratio when starting the cropper
  /// by setting the value of [AndroidUiSettings.initAspectRatio]. Default is a list of
  /// [CropAspectRatioPreset.original], [CropAspectRatioPreset.square],
  /// [CropAspectRatioPreset.ratio3x2], [CropAspectRatioPreset.ratio4x3] and
  /// [CropAspectRatioPreset.ratio16x9].
  ///
  /// * cropStyle: controls the style of crop bounds, it can be rectangle or
  /// circle style (default is [CropStyle.rectangle]).
  ///
  /// * compressFormat: the format of result image, png or jpg (default is [ImageCompressFormat.jpg])
  ///
  /// * compressQuality: the value [0 - 100] to control the quality of image compression
  ///
  /// * uiSettings: controls UI customization on specific platform (android, ios, web,...)
  ///
  /// See:
  ///  * [AndroidUiSettings] controls UI customization for Android
  ///  * [IOSUiSettings] controls UI customization for iOS
  ///
  /// **return:**
  ///
  /// A result file of the cropped image.
  ///
  /// Note: The result file is saved in NSTemporaryDirectory on iOS and application Cache directory
  /// on Android, so it can be lost later, you are responsible for storing it somewhere
  /// permanent (if needed).
  ///
  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset> aspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    CropStyle cropStyle = CropStyle.rectangle,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    WebUiSettings? webSettings;
    for (final settings in uiSettings ?? <PlatformUiSettings>[]) {
      if (settings is WebUiSettings) {
        webSettings = settings;
        break;
      }
    }
    if (webSettings == null) {
      assert(true, 'must provide WebUiSettings to run on Web');
      throw 'must provide WebUiSettings to run on Web';
    }

    final context = webSettings.context;

    final element = html.DivElement();
    final option = Options(
      boundary: webSettings.boundary ?? Boundary(width: 400, height: 400),
      viewport: webSettings.viewPort ?? ViewPort(width: 320, height: 320),
      customClass: webSettings.customClass,
      enableExif: webSettings.enableExif ?? false,
      enableOrientation: webSettings.enableOrientation ?? false,
      enableZoom: webSettings.enableZoom ?? true,
      enforceBoundary: webSettings.enforceBoundary ?? true,
      mouseWheelZoom: webSettings.mouseWheelZoom ?? true,
      showZoomer: webSettings.showZoomer ?? true,
    );
    final croppie = Croppie(element, option);
    croppie.bind(BindConfiguration(url: sourcePath));

    final viewId = 'croppie-view-${DateTime.now().millisecondsSinceEpoch}';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(viewId, (int viewId) => element);

    final cropper = HtmlElementView(
      key: UniqueKey(),
      viewType: viewId,
    );

    Future<String?> doCrop() async {
      final blob = await croppie.resultBlob();
      if (blob != null) {
        final blobUrl = html.Url.createObjectUrlFromBlob(blob);
        return blobUrl;
      }
      return null;
    }

    final cropperWidth = option.boundary?.width ?? 400;
    final cropperHeight = option.boundary?.height ?? 400;
    if (webSettings.presentStyle == CropperPresentStyle.page) {
      PageRoute<String> pageRoute;
      if (webSettings.customRouteBuilder != null) {
        pageRoute = webSettings.customRouteBuilder!(cropper, doCrop);
      } else {
        pageRoute = MaterialPageRoute(
          builder: (c) => CropperPage(
            cropper: cropper,
            crop: doCrop,
            cropperContainerWidth: cropperWidth + 50.0,
            cropperContainerHeight: cropperHeight + 50.0,
          ),
        );
      }
      final result = await Navigator.of(context).push<String>(pageRoute);

      return result != null ? CroppedFile(result) : null;
    } else {
      Dialog cropperDialog;
      if (webSettings.customDialogBuilder != null) {
        cropperDialog = webSettings.customDialogBuilder!(cropper, doCrop);
      } else {
        cropperDialog = Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: CropperDialog(
            cropper: cropper,
            crop: doCrop,
            cropperContainerWidth: cropperWidth + 50.0,
            cropperContainerHeight: cropperHeight + 50.0,
          ),
        );
      }
      final result = await showDialog<String?>(
        context: context,
        builder: (_) => cropperDialog,
      );

      return result != null ? CroppedFile(result) : null;
    }
  }
}
