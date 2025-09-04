package io.flutter.plugin.common;

import android.content.Intent;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public class PluginRegistry {

    public interface ActivityResultListener {
        boolean onActivityResult(int requestCode, int resultCode, Intent data);
    }
}
