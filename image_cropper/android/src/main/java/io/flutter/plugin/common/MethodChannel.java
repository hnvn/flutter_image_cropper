package io.flutter.plugin.common;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public class MethodChannel {
    private final BinaryMessenger messenger;
    private final String name;

    public MethodChannel(BinaryMessenger messenger, String name) {
        this.messenger = messenger;
        this.name = name;
    }

    public void setMethodCallHandler(MethodCallHandler handler) {
        // Stub implementation
    }

    public void invokeMethod(String method, Object arguments) {
        // Stub implementation
    }

    public void invokeMethod(String method, Object arguments, Result callback) {
        // Stub implementation
    }

    public interface MethodCallHandler {
        void onMethodCall(MethodCall call, Result result);
    }

    public interface Result {
        void success(Object result);
        void error(String errorCode, String errorMessage, Object errorDetails);
        void notImplemented();
    }
}
