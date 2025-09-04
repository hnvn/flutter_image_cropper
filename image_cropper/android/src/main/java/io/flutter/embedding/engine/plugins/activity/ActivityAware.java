package io.flutter.embedding.engine.plugins.activity;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public interface ActivityAware {
    void onAttachedToActivity(ActivityPluginBinding binding);
    void onDetachedFromActivityForConfigChanges();
    void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding);
    void onDetachedFromActivity();
}
