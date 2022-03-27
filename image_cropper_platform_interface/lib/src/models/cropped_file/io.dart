// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright note: this code file is copied from `image_picker` plugin

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import './base.dart';

/// A CroppedFile backed by a dart:io File.
class CroppedFile extends CroppedFileBase {
  /// Construct a PickedFile object backed by a dart:io File.
  CroppedFile(String path)
      : _file = File(path),
        super(path);

  final File _file;

  @override
  String get path {
    return _file.path;
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    return _file.readAsString(encoding: encoding);
  }

  @override
  Future<Uint8List> readAsBytes() {
    return _file.readAsBytes();
  }

  @override
  Stream<Uint8List> openRead([int? start, int? end]) {
    return _file
        .openRead(start ?? 0, end)
        .map((List<int> chunk) => Uint8List.fromList(chunk));
  }
}
