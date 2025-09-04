package io.flutter.embedding.engine.plugins.activity;

import android.app.Activity;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public interface ActivityPluginBinding {
    Activity getActivity();
    void addActivityResultListener(PluginRegistry.ActivityResultListener listener);
    void removeActivityResultListener(PluginRegistry.ActivityResultListener listener);
}
