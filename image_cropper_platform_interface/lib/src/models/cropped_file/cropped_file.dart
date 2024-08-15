// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright note: this code file is copied from `image_picker` plugin



export 'unsupported.dart'
    if (dart.library.html) 'html.dart'
    if (dart.library.io) 'io.dart';



class CropInfo {
  final String path;
  final double x, y, width, height;

  get minX => x;
  get minY => y;

  get maxX => x + width;
  get maxY => y + height;

  CropInfo(
      {required this.path,
      required this.x,
      required this.y,
      required this.width,
      required this.height});
}
