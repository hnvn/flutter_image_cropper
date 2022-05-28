@JS()
library chroppie.native;

import 'dart:html';

import 'package:js/js.dart';

import 'croppie_dart.dart';

/// Javascript Promise
@JS("Promise")
class Promise {
  external Object then(Function onFulfilled, Function onRejected);
  external static Promise resolve(dynamic value);
}

/// Configuration for binding
@JS()
@anonymous
class BindConfiguration {
  external factory BindConfiguration(
      {String url, List<String> points, int orientation, double zoom});

  external String get url;
  external List<String> get points;
  external int get orientation;
  external double get zoom;
}

/// Options for result()
@JS()
@anonymous
class ResultOptions {
  external factory ResultOptions(
      {String? type, String? size, String? format, num? quality, bool? circle});

  external String? get type;
  external String? get size;
  external String? get format;
  external num? get quality;
  external bool? get circle;
}

/// Result of the get() function.
@JS()
@anonymous
class Data {
  external factory Data({List<String> points, double zoom});

  external List<String> get points;
  external double get zoom;
}

/// Boundary configuration
@JS()
@anonymous
class Boundary {
  external factory Boundary({int width, int height});

  external int get width;
  external int get height;
}

/// Viewport configuration
@JS()
@anonymous
class ViewPort {
  external factory ViewPort({int width, int height, String type});

  external int get width;
  external int get height;
  external String get type;
}

/// Options to configure Croppie
@JS()
@anonymous
class Options {
  external factory Options(
      {Boundary? boundary,
      String? customClass,
      bool? enableExif,
      bool? enableOrientation,
      bool? enableResize,
      bool? enableZoom,
      bool? enforceBoundary,
      bool? mouseWheelZoom,
      bool? showZoomer,
      ViewPort? viewport});

  /// The outer container of the cropper
  external Boundary? get boundary;

  /// A class of your choosing to add to the container to add custom styles to your croppie
  /// Default = ''
  external String? get customClass;

  /// Enable exif orientation reading. Tells Croppie to read exif orientation from the image data and orient the image correctly before
  /// rendering to the page.
  /// Requires exif.js (packages/croppie_dart/lib/src/exif.js)
  external bool? get enableExif;

  /// Enable or disable support for specifying a custom orientation when binding images (See bind method)
  /// Default = false
  external bool? get enableOrientation;

  /// Enable or disable support for resizing the viewport area.
  /// Default = false
  external bool? get enableResize;

  /// Enable zooming functionality. If set to false - scrolling and pinching would not zoom.
  /// Default = false
  external bool? get enableZoom;

  /// Restricts zoom so image cannot be smaller than viewport.
  /// Experimental
  /// Default = true
  external bool? get enforceBoundary;

  /// Enable or disable the ability to use the mouse wheel to zoom in and out on a croppie instance
  /// Default = true
  external bool? get mouseWheelZoom;

  /// Hide or Show the zoom slider.
  /// Default = true
  external bool? get showZoomer;

  /// The inner container of the coppie. The visible part of the image.
  /// Default = { width: 100, height: 100, type: 'square' }
  /// Valid type values:'square' 'circle'
  external ViewPort? get viewport;
}

/// Croppie JS implementation.
@JS("Croppie")
class CroppieJS implements CroppieBase {
  external factory CroppieJS(Element el, Options opts);

  external Data get();

  external void destroy();

  external Promise bind(BindConfiguration conf);

  external Promise result(ResultOptions options);

  external void rotate(int degrees);

  external void setZoom(double value);
}
