package io.flutter.plugin.common;

/**
 * Stub implementation for compilation purposes.
 * This will be replaced by the actual Flutter SDK when integrated into a Flutter app.
 */
public interface BinaryMessenger {
    void send(String channel, java.nio.ByteBuffer message);
    void send(String channel, java.nio.ByteBuffer message, BinaryReply callback);
    void setMessageHandler(String channel, BinaryMessageHandler handler);

    interface BinaryReply {
        void reply(java.nio.ByteBuffer reply);
    }

    interface BinaryMessageHandler {
        void onMessage(java.nio.ByteBuffer message, BinaryReply reply);
    }
}
