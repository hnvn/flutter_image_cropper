package vn.hunghd.flutter.plugins.example;

import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        flutterEngine.getPlugins().add(new ImageCropperPlugin());
    }
}