package io.flutter.plugin.common;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public class MethodChannel {

    public interface Result {
        void success(Object result);
        void error(String errorCode, String errorMessage, Object errorDetails);
        void notImplemented();
    }
}
