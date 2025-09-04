package io.flutter.plugin.common;

import android.content.Intent;

/**
 * Minimal stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 *
 * Note: This stub is designed to avoid R8 conflicts by using different internal structure
 * while maintaining the same public interface.
 */
public class PluginRegistry {

    public interface ActivityResultListener {
        boolean onActivityResult(int requestCode, int resultCode, Intent data);
    }

    // Other interfaces that might be needed
    public interface RequestPermissionsResultListener {
        boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults);
    }

    public interface NewIntentListener {
        boolean onNewIntent(Intent intent);
    }

    public interface UserLeaveHintListener {
        void onUserLeaveHint();
    }
}
