package io.flutter.plugin.common;

import java.util.Map;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public class MethodCall {
    public final String method;
    private final Object arguments;

    public MethodCall(String method, Object arguments) {
        this.method = method;
        this.arguments = arguments;
    }

    public String method() {
        return method;
    }

    public <T> T argument(String key) {
        if (arguments instanceof Map) {
            return (T) ((Map<String, Object>) arguments).get(key);
        }
        return null;
    }

    public <T> T arguments() {
        return (T) arguments;
    }
}
