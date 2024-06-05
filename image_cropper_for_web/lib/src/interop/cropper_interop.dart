@JS()
library;

import 'dart:js_interop';

import 'package:web/web.dart';

@JS("Cropper")
extension type Cropper._(JSObject _) implements JSObject {
  external HTMLElement element;
  external CropperOptions? otpions;

  external Cropper(HTMLElement element, [CropperOptions? options]);

  external Cropper clear();

  external Cropper crop();

  external Cropper destroy();

  external Cropper disable();

  external Cropper enable();

  external CropperCanvasData getCanvasData();

  external CropperContainerData getContainerData();

  external CropperBoxData getCropBoxData();

  external HTMLCanvasElement getCroppedCanvas(
      [GetCroppedCanvasOptions? options]);

  external CropperData getData([bool? rounded]);

  external CropperImageData getImageData();

  external Cropper move(num offsetX, [num? offsetY]);

  external Cropper moveTo(num x, [num? y]);

  external Cropper replace(String url, [bool? onlyColorChanged]);

  external Cropper reset();

  external Cropper rotate(num degree);

  external Cropper rotateTo(num degree);

  external Cropper scale(num scaleX, [num? scaleY]);

  external Cropper scaleX(num scaleX);

  external Cropper scaleY(num scaleY);

  external Cropper setAspectRatio(num aspectRatio);

  external Cropper setCanvasData(SetCropperCanvasData data);

  external Cropper setCropBoxData(SetCropperBoxData data);

  external Cropper setData(SetCropperData data);

  external Cropper setDragMode(String dragMode);

  external Cropper zoom(num ratio);

  external Cropper zoomTo(num ratio, [CropperPivot? pivot]);

  external static Cropper noConflict();

  external static void setDefaults(CropperOptions options);
}

@JS()
@anonymous
extension type CropperOptions._(JSObject _) implements JSObject {
  external num? aspectRatio;
  external bool? autoCrop;
  external num? autoCropArea;
  external bool? background;
  external bool? center;
  external bool? checkCrossOrigin;
  external bool? checkOrientation;
  external bool? cropBoxMovable;
  external bool? cropBoxResizable;
  external SetCropperData? data;
  external String? dragMode;
  external bool? guides;
  external bool? highlight;
  external num? initialAspectRatio;
  external num? minCanvasHeight;
  external num? minCanvasWidth;
  external num? minContainerHeight;
  external num? minContainerWidth;
  external num? minCropBoxHeight;
  external num? minCropBoxWidth;
  external bool? modal;
  external bool? movable;
  external JSAny? preview;
  external bool? responsive;
  external bool? restore;
  external bool? rotatable;
  external bool? scalable;
  external bool? toggleDragModeOnDblclick;
  external int? viewMode;
  external num? wheelZoomRatio;
  external bool? zoomOnTouch;
  external bool? zoomOnWheel;
  external bool? zoomable;

  external CropperOptions({
    num? aspectRatio,
    bool? autoCrop,
    num? autoCropArea,
    bool? background,
    bool? center,
    bool? checkCrossOrigin,
    bool? checkOrientation,
    bool? cropBoxMovable,
    bool? cropBoxResizable,
    SetCropperData? data,
    String? dragMode,
    bool? guides,
    bool? highlight,
    num? initialAspectRatio,
    num? minCanvasHeight,
    num? minCanvasWidth,
    num? minContainerHeight,
    num? minContainerWidth,
    num? minCropBoxHeight,
    num? minCropBoxWidth,
    bool? modal,
    bool? movable,
    JSAny? preview,
    bool? responsive,
    bool? restore,
    bool? rotatable,
    bool? scalable,
    bool? toggleDragModeOnDblclick,
    int? viewMode,
    num? wheelZoomRatio,
    bool? zoomOnTouch,
    bool? zoomOnWheel,
    bool? zoomable,
  });
}

@JS()
@anonymous
extension type CropperPivot._(JSObject _) implements JSObject {
  external num x;
  external num y;

  external CropperPivot({
    num x,
    num y,
  });
}

@JS()
@anonymous
extension type CropperData._(JSObject _) implements JSObject {
  external num x;
  external num y;
  external num width;
  external num height;
  external num rotate;
  external num scaleX;
  external num scaleY;

  external CropperData({
    num x,
    num y,
    num width,
    num height,
    num rotate,
    num scaleX,
    num scaleY,
  });
}

@JS()
@anonymous
extension type CropperContainerData._(JSObject _) implements JSObject {
  external num width;
  external num height;

  external CropperContainerData({
    num width,
    num height,
  });
}

@JS()
@anonymous
extension type CropperImageData._(JSObject _) implements JSObject {
  external num left;
  external num top;
  external num width;
  external num height;
  external num rotate;
  external num scaleX;
  external num scaleY;
  external num naturalWidth;
  external num naturalHeight;
  external num aspectRatio;

  external CropperImageData({
    num left,
    num top,
    num width,
    num height,
    num rotate,
    num scaleX,
    num scaleY,
    num naturalWidth,
    num naturalHeight,
    num aspectRatio,
  });
}

@JS()
@anonymous
extension type CropperCanvasData._(JSObject _) implements JSObject {
  external num left;
  external num top;
  external num width;
  external num height;
  external num naturalWidth;
  external num naturalHeight;

  external CropperCanvasData({
    num left,
    num top,
    num width,
    num height,
    num naturalWidth,
    num naturalHeight,
  });
}

@JS()
@anonymous
extension type CropperBoxData._(JSObject _) implements JSObject {
  external num left;
  external num top;
  external num width;
  external num height;

  external CropperBoxData({
    num left,
    num top,
    num width,
    num height,
  });
}

@JS()
@anonymous
extension type GetCroppedCanvasOptions._(JSObject _) implements JSObject {
  external num? width;
  external num? height;
  external num? minWidth;
  external num? minHeight;
  external num? maxWidth;
  external num? maxHeight;
  external bool? rounded;
  external String? fillColor;
  external bool? imageSmoothingEnabled;
  external ImageSmoothingQuality? imageSmoothingQuality;

  external GetCroppedCanvasOptions({
    num? width,
    num? height,
    num? minWidth,
    num? minHeight,
    num? maxWidth,
    num? maxHeight,
    bool? rounded,
    String? fillColor,
    bool? imageSmoothingEnabled,
    ImageSmoothingQuality? imageSmoothingQuality,
  });
}

@JS()
@anonymous
extension type SetCropperData._(JSObject _) implements JSObject {
  external num? x;
  external num? y;
  external num? width;
  external num? height;
  external num? rotate;
  external num? scaleX;
  external num? scaleY;

  external SetCropperData({
    num? x,
    num? y,
    num? width,
    num? height,
    num? rotate,
    num? scaleX,
    num? scaleY,
  });
}

@JS()
@anonymous
extension type SetCropperCanvasData._(JSObject _) implements JSObject {
  external num? left;
  external num? top;
  external num? width;
  external num? height;

  external SetCropperCanvasData({
    num? left,
    num? top,
    num? width,
    num? height,
  });
}

@JS()
@anonymous
extension type SetCropperBoxData._(JSObject _) implements JSObject {
  external num? left;
  external num? top;
  external num? width;
  external num? height;

  external SetCropperBoxData({
    num? left,
    num? top,
    num? width,
    num? height,
  });
}
