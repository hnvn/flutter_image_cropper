package io.flutter.plugin.common;

import java.util.Map;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public class MethodCall {
    public final String method;
    public final Object arguments;

    public MethodCall(String method, Object arguments) {
        this.method = method;
        this.arguments = arguments;
    }

    @SuppressWarnings("unchecked")
    public <T> T argument(String key) {
        if (arguments == null) {
            return null;
        }
        if (arguments instanceof Map) {
            return (T) ((Map<?, ?>) arguments).get(key);
        }
        return null;
    }

    public boolean hasArgument(String key) {
        if (arguments == null) {
            return false;
        }
        if (arguments instanceof Map) {
            return ((Map<?, ?>) arguments).containsKey(key);
        }
        return false;
    }
}
