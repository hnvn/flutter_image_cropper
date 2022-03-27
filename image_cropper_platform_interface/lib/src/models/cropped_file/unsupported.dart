// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright note: this code file is copied from `image_picker` plugin

import './base.dart';

/// A CroppedFile is a cross-platform, simplified File abstraction.
///
/// It wraps the bytes of a selected file, and its (platform-dependant) path.
class CroppedFile extends CroppedFileBase {
  /// Construct a CroppedFile object, from its `bytes`.
  ///
  /// Optionally, you may pass a `path`. See caveats in [CroppedFileBase.path].
  CroppedFile(String path) : super(path) {
    throw UnimplementedError(
        'CroppedFile is not available in your current platform.');
  }
}
