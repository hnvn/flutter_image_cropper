package vn.hunghd.flutter.plugins.imagecropper;

import android.app.Activity;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import androidx.appcompat.app.AppCompatDelegate;

/** ImageCropperPlugin */
public class ImageCropperPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {
  static
  {
    AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
  }
  private static final String CHANNEL = "plugins.hunghd.vn/image_cropper";

  private static ImageCropperPlugin instance;
  private static MethodChannel channel;
  private static ImageCropperDelegate delegate;

  private Activity activity;
  private final Object initializationLock = new Object();

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    if (instance == null) {
      instance = new ImageCropperPlugin();
    }
    if (registrar.activity() != null) {
      instance.onAttachedToEngine(registrar.messenger());
      instance.onAttachedToActivity(registrar.activity());
      registrar.addActivityResultListener(instance.getActivityResultListener());
    }
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (activity == null || delegate == null) {
      result.error("no_activity", "image_cropper plugin requires a foreground activity.", null);
      return;
    }
    if (call.method.equals("cropImage")) {
      delegate.startCrop(call, result);
    }
  }

  private void onAttachedToEngine(BinaryMessenger messenger) {
    synchronized (initializationLock) {
      if (channel != null) {
        return;
      }

      channel = new MethodChannel(messenger, CHANNEL);
      channel.setMethodCallHandler(this);
    }
  }

  private void onAttachedToActivity(Activity activity) {
    this.activity = activity;
    delegate = new ImageCropperDelegate(activity);
  }

  private PluginRegistry.ActivityResultListener getActivityResultListener() {
    return delegate;
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
  }


  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    if (getActivityResultListener() != null) {
      binding.removeActivityResultListener(getActivityResultListener());
    }
    onAttachedToActivity(binding.getActivity());
    binding.addActivityResultListener(getActivityResultListener());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
    delegate = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    if (getActivityResultListener() != null) {
      binding.removeActivityResultListener(getActivityResultListener());
    }
    onAttachedToActivity(binding.getActivity());
    binding.addActivityResultListener(getActivityResultListener());
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
    delegate = null;
  }
}
