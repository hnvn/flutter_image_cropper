// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package vn.hunghd.flutter.plugins.imagecropper;

import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import io.flutter.plugin.common.MethodCall;
import java.util.HashMap;
import java.util.Map;

class ImageCropperCache {

  static final String MAP_KEY_PATH = "path";
  private static final String MAP_KEY_ERROR_CODE = "errorCode";
  private static final String MAP_KEY_ERROR_MESSAGE = "errorMessage";

  private static final String FLUTTER_IMAGE_CROPPER_IMAGE_PATH_KEY =
      "flutter_image_cropper_image_path";
  private static final String SHARED_PREFERENCE_ERROR_CODE_KEY = "flutter_image_cropper_error_code";
  private static final String SHARED_PREFERENCE_ERROR_MESSAGE_KEY =
      "flutter_image_cropper_error_message";


  @VisibleForTesting
  private static final String SHARED_PREFERENCES_NAME = "flutter_image_cropper_shared_preference";

  private SharedPreferences prefs;

  ImageCropperCache(Context context) {
    prefs = context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
  }


  void saveResult(
      @Nullable String path, @Nullable String errorCode, @Nullable String errorMessage) {

    SharedPreferences.Editor editor = prefs.edit();
    if (path != null) {
      editor.putString(FLUTTER_IMAGE_CROPPER_IMAGE_PATH_KEY, path);
    }
    if (errorCode != null) {
      editor.putString(SHARED_PREFERENCE_ERROR_CODE_KEY, errorCode);
    }
    if (errorMessage != null) {
      editor.putString(SHARED_PREFERENCE_ERROR_MESSAGE_KEY, errorMessage);
    }
    editor.apply();
  }

  void clear() {
    prefs.edit().clear().apply();
  }

  Map<String, Object> getCacheMap() {

    Map<String, Object> resultMap = new HashMap<>();

    if (prefs.contains(FLUTTER_IMAGE_CROPPER_IMAGE_PATH_KEY)) {
      final String imagePathValue = prefs.getString(FLUTTER_IMAGE_CROPPER_IMAGE_PATH_KEY, "");
      resultMap.put(MAP_KEY_PATH, imagePathValue);
    }

    if (prefs.contains(SHARED_PREFERENCE_ERROR_CODE_KEY)) {
      final String errorCodeValue = prefs.getString(SHARED_PREFERENCE_ERROR_CODE_KEY, "");
      resultMap.put(MAP_KEY_ERROR_CODE, errorCodeValue);
      if (prefs.contains(SHARED_PREFERENCE_ERROR_MESSAGE_KEY)) {
        final String errorMessageValue = prefs.getString(SHARED_PREFERENCE_ERROR_MESSAGE_KEY, "");
        resultMap.put(MAP_KEY_ERROR_MESSAGE, errorMessageValue);
      }
    }

    return resultMap;
  }
}
