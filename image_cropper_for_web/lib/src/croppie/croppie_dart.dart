import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:js/js.dart';

import 'croppie_dart_base.dart';

export 'croppie_dart_base.dart';

/// Interface for original Croppie functionality.
abstract class CroppieBase {
  Data get();

  /// Destroy a croppie instance and remove it from the DOM.
  void destroy();

  ///Bind an image the croppie. Returns a promise to be resolved when the image has been loaded and the croppie has been initialized.
  /// Parameters
  /// url = URL to image
  /// points = Array of points that translate into [topLeftX, topLeftY, bottomRightX, bottomRightY]
  /// zoom = Apply zoom after image has been bound
  /// orientation =  Custom orientation, applied after exif orientation (if enabled). Only works with enableOrientation option enabled (see 'Options').
  /// Valid options are:
  ///   1 unchanged
  ///   2 flipped horizontally
  ///   3 rotated 180 degrees
  ///   4 flipped vertically
  ///   5 flipped horizontally, then rotated left by 90 degrees
  ///   6 rotated clockwise by 90 degrees
  ///   7 flipped horizontally, then rotated right by 90 degrees
  ///   8 rotated counter-clockwise by 90 degrees
  Promise bind(BindConfiguration configuration);

  /// Get the resulting crop of the image.
  /// Parameters
  /// type = The type of result to return defaults to 'canvas'
  ///     'base64' returns a the cropped image encoded in base64
  ///     'html' returns html of the image positioned within an div of hidden overflow
  ///     'blob' returns a blob of the cropped image
  ///     'rawcanvas' returns the canvas element allowing you to manipulate prior to getting the resulted image
  /// size = The size of the cropped image defaults to 'viewport'
  ///     'viewport' the size of the resulting image will be the same width and height as the viewport
  ///     'original' the size of the resulting image will be at the original scale of the image
  ///     {width, height} an object defining the width and height. If only one dimension is specified,
  ///     the other will be calculated using the viewport aspect ratio.
  /// format = Indicating the image format.
  ///     Default = 'png'
  ///     Valid values:'jpeg'|'png'|'webp'
  /// quality = Number between 0 and 1 indicating image quality.
  ///     Default = 1
  /// circle = force the result to be cropped into a circle
  ///     Valid Values: bool
  Promise result(
      String type, String size, String format, num quality, bool circle);

  /// Rotate the image by a specified degree amount. Only works with enableOrientation option enabled (see 'Options').
  /// degrees Valid Values: 90, 180, 270, -90, -180, -270
  void rotate(int degrees);

  /// Set the zoom of a Croppie instance. The value passed in is still restricted to the min/max set by Croppie.
  /// value a floating point to scale the image within the croppie. Must be between a min and max value set by croppie.
  void setZoom(double value);
}

/// Convenience extension for the Croppie base functionality.
abstract class Croppie implements CroppieBase {
  factory Croppie(Element el, Options opts) {
    return _Croppie(el, opts);
  }

  /// Simple async
  Future<T> resultAsync<T>({
    String? type,
    String? size,
    String? format,
    num? quality,
    bool? circle,
  });

  /// Async base64 encoded string
  Future<String?> resultBase64({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  });

  /// Async html element
  Future<T> resultHtml<T extends Element>({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  });

  /// Async blob
  Future<Blob?> resultBlob({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  });

  /// Async byte array
  Future<Uint8List?> resultByteArray({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  });

  /// Async canvas element
  Future<CanvasElement?> resultRawCanvas({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  });

  Future<dynamic> bindAsync(BindConfiguration conf);
}

/// Wrapper implementation
class _Croppie implements Croppie {
  final Options opts;
  final Element cropElement;
  final CroppieJS impl;

  _Croppie(this.cropElement, this.opts) : impl = CroppieJS(cropElement, opts);

  @override
  void setZoom(value) {
    impl.setZoom(value);
  }

  @override
  void rotate(int degrees) {
    impl.rotate(degrees);
  }

  @override
  Promise result(
      String? type, String? size, String? format, num? quality, bool? circle) {
    return impl.result(type, size, format, quality, circle);
  }

  @override
  Future<T> resultAsync<T>({
    String? type,
    String? size,
    String? format,
    num? quality,
    bool? circle,
  }) {
    Promise promise = result(type, size, format, quality, circle);
    return _completerForPromise<T>(promise).future;
  }

  @override
  Future<String?> resultBase64({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  }) {
    Promise promise = result("base64", size, format, quality, circle);
    return _completerForPromise<String?>(promise).future;
  }

  @override
  Future<T> resultHtml<T extends Element>({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  }) {
    Promise promise = result("html", size, format, quality, circle);
    return _completerForPromise<T>(promise).future;
  }

  @override
  Future<Blob?> resultBlob({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  }) {
    Promise promise = result("blob", size, format, quality, circle);
    return _completerForPromise<Blob?>(promise).future;
  }

  @override
  Future<Uint8List?> resultByteArray({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  }) async {
    Blob? blob = await resultBlob(
        size: size, format: format, quality: quality, circle: circle);

    Completer<Uint8List?> out = Completer();

    // Convert blob to Uint8List
    FileReader fr = FileReader();
    fr.onLoadEnd.listen((ProgressEvent event) {
      out.complete(fr.result as Uint8List?);
    }, onError: (error, StackTrace st) {
      out.completeError(error, st);
    });

    if (blob != null) {
      fr.readAsArrayBuffer(blob);
    } else {
      out.complete(null);
    }

    return out.future;
  }

  @override
  Future<CanvasElement?> resultRawCanvas({
    String? size,
    String? format,
    num? quality,
    bool? circle,
  }) async {
    Promise promise = result("rawcanvas", size, format, quality, circle);
    return _completerForPromise<CanvasElement?>(promise).future;
  }

  @override
  Promise bind(BindConfiguration conf) {
    return impl.bind(conf);
  }

  @override
  Future<dynamic> bindAsync(BindConfiguration conf) {
    Promise promise = impl.bind(conf);
    return _completerForPromise(promise).future;
  }

  @override
  void destroy() {
    impl.destroy();
  }

  @override
  Data get() {
    return impl.get();
  }
}

/// Creates a completer for the given JS promise.
Completer<T> _completerForPromise<T>(Promise promise) {
  Completer<T> out = Completer();

  // Create interopts for promise
  promise.then(allowInterop((value) {
    out.complete(value);
  }), allowInterop(([value]) {
    out.completeError(value, StackTrace.current);
  }));

  return out;
}
