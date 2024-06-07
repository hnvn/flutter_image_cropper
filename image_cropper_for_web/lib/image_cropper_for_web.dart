library image_cropper_for_web;

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_cropper_for_web/src/cropper_dialog.dart';
import 'package:image_cropper_for_web/src/cropper_page.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

import 'src/interop/cropper_interop.dart';

/// The web implementation of [ImageCropperPlatform].
///
/// This class implements the `package:image_picker` functionality for the web.
class ImageCropperPlugin extends ImageCropperPlatform {
  /// Registers this class as the default instance of [ImageCropperPlatform].
  static void registerWith(Registrar registrar) {
    ImageCropperPlatform.instance = ImageCropperPlugin();
  }

  static int _nextIFrameId = 0;

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
  /// * compressFormat: the format of result image, png or jpg (IGNORED)
  ///
  /// * compressQuality: the value [0 - 100] to control the quality of image compression (IGNORED)
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
    final cropperWidth = webSettings.size?.width ?? 500;
    final cropperHeight = webSettings.size?.height ?? 500;

    final div = web.HTMLDivElement()
      ..id = 'cropperView_${_nextIFrameId++}'
      ..style.width = '100%'
      ..style.height = '100%';
    final image = web.HTMLImageElement()
      ..src = sourcePath
      ..style.maxWidth = '100%'
      ..style.display = 'block';
    div.appendChild(image);

    final options = CropperOptions(
      dragMode:
          webSettings.dragMode != null ? webSettings.dragMode!.value : 'crop',
      viewMode:
          webSettings.viewwMode != null ? webSettings.viewwMode!.value : 0,
      initialAspectRatio: webSettings.initialAspectRatio,
      aspectRatio:
          aspectRatio != null ? aspectRatio.ratioX / aspectRatio.ratioY : null,
      checkCrossOrigin: webSettings.checkCrossOrigin ?? true,
      checkOrientation: webSettings.checkOrientation ?? true,
      modal: webSettings.modal ?? true,
      guides: webSettings.guides ?? true,
      center: webSettings.center ?? true,
      highlight: webSettings.highlight ?? true,
      background: webSettings.background ?? true,
      movable: webSettings.movable ?? true,
      rotatable: webSettings.rotatable ?? true,
      scalable: webSettings.scalable ?? true,
      zoomable: webSettings.zoomable ?? true,
      zoomOnTouch: webSettings.zoomOnTouch ?? true,
      zoomOnWheel: webSettings.zoomOnWheel ?? true,
      wheelZoomRatio: webSettings.wheelZoomRatio ?? 0.1,
      cropBoxMovable: webSettings.cropBoxMovable ?? true,
      cropBoxResizable: webSettings.cropBoxResizable ?? true,
      toggleDragModeOnDblclick: webSettings.toggleDragModeOnDblclick ?? true,
      minContainerWidth: webSettings.minContainerWidth ?? 200,
      minContainerHeight: webSettings.minContainerHeight ?? 100,
      minCropBoxWidth: webSettings.minCropBoxWidth ?? 0,
      minCropBoxHeight: webSettings.minCropBoxHeight ?? 0,
    );
    Cropper? cropper;
    initializer() => Future.delayed(
          const Duration(milliseconds: 200),
          () {
            assert(cropper == null, 'cropper was already initialized');
            cropper = Cropper(image, options);
          },
        );

    final viewType =
        'plugins.hunghd.vn/cropper-view-${Uri.encodeComponent(sourcePath)}';

    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) => div);

    final cropperWidget = HtmlElementView(
      key: ValueKey(sourcePath),
      viewType: viewType,
    );

    Future<String?> doCrop() async {
      if (cropper != null) {
        final result = (maxWidth != null || maxHeight != null)
            ? cropper!.getCroppedCanvas(GetCroppedCanvasOptions(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ))
            : cropper!.getCroppedCanvas();
        final completer = Completer<String>();
        result.toBlob((web.Blob blob) {
          completer.complete(web.URL.createObjectURL(blob));
        }.toJS);
        return completer.future;
      } else {
        return Future.error('cropper has not been initialized');
      }
    }

    void doRotate(RotationAngle angle) {
      if (cropper == null) throw 'cropper has not been initialized';
      cropper?.rotate(rotationAngleToNumber(angle));
    }

    void doScale(num value) {
      if (cropper == null) throw 'cropper has not been initialized';
      cropper?.scale(value);
    }

    if (webSettings.presentStyle == WebPresentStyle.page) {
      PageRoute<String> pageRoute;
      if (webSettings.customRouteBuilder != null) {
        pageRoute = webSettings.customRouteBuilder!(
          cropperWidget,
          initializer,
          doCrop,
          doRotate,
          doScale,
        );
      } else {
        pageRoute = MaterialPageRoute(
          builder: (c) => CropperPage(
            cropper: cropperWidget,
            initCropper: initializer,
            crop: doCrop,
            rotate: doRotate,
            scale: doScale,
            cropperContainerWidth: cropperWidth * 1.0,
            cropperContainerHeight: cropperHeight * 1.0,
            translations:
                webSettings?.translations ?? const WebTranslations.en(),
            themeData: webSettings?.themeData,
          ),
        );
      }
      final result = await Navigator.of(context).push<String>(pageRoute);

      return result != null ? CroppedFile(result) : null;
    } else {
      Widget cropperDialog;
      if (webSettings.customDialogBuilder != null) {
        cropperDialog = webSettings.customDialogBuilder!(
          cropperWidget,
          initializer,
          doCrop,
          doRotate,
          doScale,
        );
      } else {
        cropperDialog = CropperDialog(
          cropper: cropperWidget,
          initCropper: initializer,
          crop: doCrop,
          rotate: doRotate,
          scale: doScale,
          cropperContainerWidth: cropperWidth * 1.0,
          cropperContainerHeight: cropperHeight * 1.0,
          translations: webSettings.translations ?? const WebTranslations.en(),
          themeData: webSettings.themeData,
        );
      }
      final result = await showDialog<String?>(
        context: context,
        barrierColor: webSettings.barrierColor,
        barrierDismissible: false,
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
