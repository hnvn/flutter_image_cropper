package io.flutter.embedding.engine.plugins;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public interface FlutterPlugin {

    void onAttachedToEngine(FlutterPluginBinding binding);
    void onDetachedFromEngine(FlutterPluginBinding binding);

    class FlutterPluginBinding {
        public BinaryMessenger getBinaryMessenger() {
            return null;
        }
    }
}
