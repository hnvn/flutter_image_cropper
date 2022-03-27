import 'package:flutter/material.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

import 'croppie/croppie_dart_base.dart';

typedef CropperDialogBuilder = Dialog Function(
    Widget cropper, Future<String?> Function() crop);

typedef CropperRouteBuilder = PageRoute<String> Function(
    Widget cropper, Future<String?> Function() crop);

enum CropperPresentStyle { dialog, page }

class WebUiSettings extends PlatformUiSettings {
  /// The outer container of the cropper
  /// Default = { width: 500, height: 500 }
  final Boundary? boundary;

  /// The inner container of the coppie. The visible part of the image.
  /// Default = { width: 400, height: 400, type: 'square' }
  /// Valid type values:'square' 'circle'
  final ViewPort? viewPort;

  /// A class of your choosing to add to the container to add custom styles to your croppie
  /// Default = ''
  final String? customClass;

  /// Enable exif orientation reading. Tells Croppie to read exif orientation from the image data and orient the image correctly before
  /// rendering to the page.
  /// Requires exif.js (packages/croppie_dart/lib/src/exif.js)
  final bool? enableExif;

  /// Enable or disable support for specifying a custom orientation when binding images
  /// Default = false
  final bool? enableOrientation;

  /// Enable zooming functionality. If set to false - scrolling and pinching would not zoom.
  /// Default = false
  final bool? enableZoom;

  /// Enable or disable support for resizing the viewport area.
  /// Default = false
  final bool? enableResize;

  /// Restricts zoom so image cannot be smaller than viewport.
  /// Experimental
  /// Default = true
  final bool? enforceBoundary;

  /// Enable or disable the ability to use the mouse wheel to zoom in and out on a croppie instance
  /// Default = true
  final bool? mouseWheelZoom;

  /// Hide or Show the zoom slider.
  /// Default = true
  final bool? showZoomer;

  /// Presentation style of cropper, either a dialog or a page (route)
  /// Default = dialog
  final CropperPresentStyle presentStyle;

  /// Current BuildContext
  /// The context is required to show cropper dialog or route
  final BuildContext context;

  /// Builder to customize the cropper [Dialog]
  final CropperDialogBuilder? customDialogBuilder;

  /// Builder to customize the cropper [PageRoute]
  final CropperRouteBuilder? customRouteBuilder;

  WebUiSettings({
    required this.context,
    this.presentStyle = CropperPresentStyle.dialog,
    this.customDialogBuilder,
    this.customRouteBuilder,
    this.boundary,
    this.viewPort,
    this.customClass,
    this.enableExif,
    this.enableOrientation,
    this.enableZoom,
    this.enableResize,
    this.enforceBoundary,
    this.mouseWheelZoom,
    this.showZoomer,
  });

  @override
  Map<String, dynamic> toMap() => {};
}
