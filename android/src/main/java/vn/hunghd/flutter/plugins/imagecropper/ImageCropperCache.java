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
  static final String MAP_KEY_MAX_WIDTH = "maxWidth";
  static final String MAP_KEY_MAX_HEIGHT = "maxHeight";
  static final String MAP_KEY_IMAGE_QUALITY = "imageQuality";
  private static final String MAP_KEY_TYPE = "type";
  private static final String MAP_KEY_ERROR_CODE = "errorCode";
  private static final String MAP_KEY_ERROR_MESSAGE = "errorMessage";

  private static final String FLUTTER_IMAGE_CROPPER_IMAGE_PATH_KEY =
      "flutter_image_cropper_image_path";
  private static final String SHARED_PREFERENCE_ERROR_CODE_KEY = "flutter_image_cropper_error_code";
  private static final String SHARED_PREFERENCE_ERROR_MESSAGE_KEY =
      "flutter_image_cropper_error_message";

  private static final String SHARED_PREFERENCE_MAX_WIDTH_KEY = "flutter_image_cropper_max_width";

  private static final String SHARED_PREFERENCE_MAX_HEIGHT_KEY = "flutter_image_cropper_max_height";

  private static final String SHARED_PREFERENCE_IMAGE_QUALITY_KEY =
      "flutter_image_cropper_image_quality";

  private static final String SHARED_PREFERENCE_TYPE_KEY = "flutter_image_cropper_type";
  private static final String SHARED_PREFERENCE_PENDING_IMAGE_URI_PATH_KEY =
      "flutter_image_cropper_pending_image_uri";

  @VisibleForTesting
  static final String SHARED_PREFERENCES_NAME = "flutter_image_cropper_shared_preference";

  private SharedPreferences prefs;

  ImageCropperCache(Context context) {
    prefs = context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
  }

  void saveTypeWithMethodCallName(String methodCallName) {
    setType("image");
  }

  private void setType(String type) {

    prefs.edit().putString(SHARED_PREFERENCE_TYPE_KEY, type).apply();
  }

  void saveDimensionWithMethodCall(MethodCall methodCall) {
    Double maxWidth = methodCall.argument(MAP_KEY_MAX_WIDTH);
    Double maxHeight = methodCall.argument(MAP_KEY_MAX_HEIGHT);
    int imageQuality =
        methodCall.argument(MAP_KEY_IMAGE_QUALITY) == null
            ? 100
            : (int) methodCall.argument(MAP_KEY_IMAGE_QUALITY);

    setMaxDimension(maxWidth, maxHeight, imageQuality);
  }

  private void setMaxDimension(Double maxWidth, Double maxHeight, int imageQuality) {
    SharedPreferences.Editor editor = prefs.edit();
    if (maxWidth != null) {
      editor.putLong(SHARED_PREFERENCE_MAX_WIDTH_KEY, Double.doubleToRawLongBits(maxWidth));
    }
    if (maxHeight != null) {
      editor.putLong(SHARED_PREFERENCE_MAX_HEIGHT_KEY, Double.doubleToRawLongBits(maxHeight));
    }
    if (imageQuality > -1 && imageQuality < 101) {
      editor.putInt(SHARED_PREFERENCE_IMAGE_QUALITY_KEY, imageQuality);
    } else {
      editor.putInt(SHARED_PREFERENCE_IMAGE_QUALITY_KEY, 100);
    }
    editor.apply();
  }

  void savePendingCameraMediaUriPath(Uri uri) {
    prefs.edit().putString(SHARED_PREFERENCE_PENDING_IMAGE_URI_PATH_KEY, uri.getPath()).apply();
  }

  String retrievePendingCameraMediaUriPath() {

    return prefs.getString(SHARED_PREFERENCE_PENDING_IMAGE_URI_PATH_KEY, "");
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
    boolean hasData = false;

    if (prefs.contains(FLUTTER_IMAGE_CROPPER_IMAGE_PATH_KEY)) {
      final String imagePathValue = prefs.getString(FLUTTER_IMAGE_CROPPER_IMAGE_PATH_KEY, "");
      resultMap.put(MAP_KEY_PATH, imagePathValue);
      hasData = true;
    }

    if (prefs.contains(SHARED_PREFERENCE_ERROR_CODE_KEY)) {
      final String errorCodeValue = prefs.getString(SHARED_PREFERENCE_ERROR_CODE_KEY, "");
      resultMap.put(MAP_KEY_ERROR_CODE, errorCodeValue);
      hasData = true;
      if (prefs.contains(SHARED_PREFERENCE_ERROR_MESSAGE_KEY)) {
        final String errorMessageValue = prefs.getString(SHARED_PREFERENCE_ERROR_MESSAGE_KEY, "");
        resultMap.put(MAP_KEY_ERROR_MESSAGE, errorMessageValue);
      }
    }

    if (hasData) {
      if (prefs.contains(SHARED_PREFERENCE_TYPE_KEY)) {
        final String typeValue = prefs.getString(SHARED_PREFERENCE_TYPE_KEY, "");
        resultMap.put(MAP_KEY_TYPE, typeValue);
      }
      if (prefs.contains(SHARED_PREFERENCE_MAX_WIDTH_KEY)) {
        final long maxWidthValue = prefs.getLong(SHARED_PREFERENCE_MAX_WIDTH_KEY, 0);
        resultMap.put(MAP_KEY_MAX_WIDTH, Double.longBitsToDouble(maxWidthValue));
      }
      if (prefs.contains(SHARED_PREFERENCE_MAX_HEIGHT_KEY)) {
        final long maxHeightValue = prefs.getLong(SHARED_PREFERENCE_MAX_HEIGHT_KEY, 0);
        resultMap.put(MAP_KEY_MAX_HEIGHT, Double.longBitsToDouble(maxHeightValue));
      }
      if (prefs.contains(SHARED_PREFERENCE_IMAGE_QUALITY_KEY)) {
        final int imageQuality = prefs.getInt(SHARED_PREFERENCE_IMAGE_QUALITY_KEY, 100);
        resultMap.put(MAP_KEY_IMAGE_QUALITY, imageQuality);
      } else {
        resultMap.put(MAP_KEY_IMAGE_QUALITY, 100);
      }
    }

    return resultMap;
  }
}
