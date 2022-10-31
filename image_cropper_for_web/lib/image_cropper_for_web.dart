library image_cropper_for_web;

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_cropper_for_web/src/cropper_dialog.dart';
import 'package:image_cropper_for_web/src/cropper_page.dart';
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
  /// * maxWidth: maximum cropped image width. (IGNORED)
  ///
  /// * maxHeight: maximum cropped image height. (IGNORED)
  ///
  /// * aspectRatio: controls the aspect ratio of crop bounds. If this values is set,
  /// the cropper is locked and user can't change the aspect ratio of crop bounds.
  /// (IGNORED)
  ///
  /// * aspectRatioPresets: controls the list of aspect ratios in the crop menu view.
  /// In Android, you can set the initialized aspect ratio when starting the cropper
  /// by setting the value of [AndroidUiSettings.initAspectRatio]. Default is a list of
  /// [CropAspectRatioPreset.original], [CropAspectRatioPreset.square],
  /// [CropAspectRatioPreset.ratio3x2], [CropAspectRatioPreset.ratio4x3] and
  /// [CropAspectRatioPreset.ratio16x9]. (IGNORED)
  ///
  /// * cropStyle: controls the style of crop bounds, it can be rectangle or
  /// circle style (default is [CropStyle.rectangle]). This field can be overrided
  /// by [WebUiSettings.viewPort.type]
  ///
  /// * compressFormat: the format of result image, png or jpg (default is [ImageCompressFormat.jpg])
  ///
  /// * compressQuality: the value [0 - 100] to control the quality of image compression
  ///
  /// * uiSettings: controls UI customization on specific platform (android, ios, web,...).
  /// This field is required and must provide [WebUiSettings]
  ///
  /// **return:**
  ///
  /// A result file of the cropped image.
  ///
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
    final shapeType = cropStyle == CropStyle.circle ? 'circle' : 'square';

    final element = html.DivElement();
    final option = Options(
      boundary: webSettings.boundary == null
          ? Boundary(width: 500, height: 500)
          : Boundary(
              width: webSettings.boundary!.width ?? 500,
              height: webSettings.boundary!.height ?? 500,
            ),
      viewport: webSettings.viewPort == null
          ? ViewPort(width: 400, height: 400, type: shapeType)
          : ViewPort(
              width: webSettings.viewPort!.width ?? 400,
              height: webSettings.viewPort!.height ?? 400,
              type: webSettings.viewPort!.type ?? shapeType,
            ),
      customClass: webSettings.customClass,
      enableExif: webSettings.enableExif ?? true,
      enableOrientation: webSettings.enableOrientation ?? true,
      enableZoom: webSettings.enableZoom ?? false,
      enableResize: webSettings.enableResize ?? false,
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

    final format = compressFormat == ImageCompressFormat.png ? 'png' : 'jpeg';
    final quality = compressQuality * 1.0 / 100;

    Future<String?> doCrop() async {
      final blob = await croppie.resultBlob(
        format: format,
        quality: quality,
      );
      if (blob != null) {
        final blobUrl = html.Url.createObjectUrlFromBlob(blob);
        return blobUrl;
      }
      return null;
    }

    void doRotate(RotationAngle angle) {
      croppie.rotate(rotationAngleToNumber(angle));
    }

    final cropperWidth = option.boundary?.width ?? 500;
    final cropperHeight = option.boundary?.height ?? 500;
    if (webSettings.presentStyle == CropperPresentStyle.page) {
      PageRoute<String> pageRoute;
      if (webSettings.customRouteBuilder != null) {
        pageRoute = webSettings.customRouteBuilder!(cropper, doCrop, doRotate);
      } else {
        pageRoute = MaterialPageRoute(
          builder: (c) => CropperPage(
            cropper: cropper,
            crop: doCrop,
            rotate: doRotate,
            cropperContainerWidth: cropperWidth + 50.0,
            cropperContainerHeight: cropperHeight + 50.0,
            translations:
                webSettings?.translations ?? const WebTranslations.en(),
          ),
        );
      }
      final result = await Navigator.of(context).push<String>(pageRoute);

      return result != null ? CroppedFile(result) : null;
    } else {
      Dialog cropperDialog;
      if (webSettings.customDialogBuilder != null) {
        cropperDialog =
            webSettings.customDialogBuilder!(cropper, doCrop, doRotate);
      } else {
        cropperDialog = Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: CropperDialog(
            cropper: cropper,
            crop: doCrop,
            rotate: doRotate,
            cropperContainerWidth: cropperWidth + 50.0,
            cropperContainerHeight: cropperHeight + 50.0,
            translations:
                webSettings.translations ?? const WebTranslations.en(),
          ),
        );
      }
      final result = await showDialog<String?>(
        context: context,
        barrierColor: webSettings.barrierColor,
        builder: (_) => cropperDialog,
      );

      return result != null ? CroppedFile(result) : null;
    }
  }

  ///
  /// Not applicable on web, see Android implementation.
  ///
  @override
  Future<CroppedFile?> recoverImage() async {
    return null;
  }
}
