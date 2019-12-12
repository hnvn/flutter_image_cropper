package vn.hunghd.flutter.plugins.imagecropper;

import com.yalantis.ucrop.UCrop;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import androidx.appcompat.app.AppCompatDelegate;

/** ImageCropperPlugin */
public class ImageCropperPlugin implements MethodCallHandler {
  static
  {
    AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
  }
  private static final String CHANNEL = "plugins.hunghd.vn/image_cropper";

  private final Registrar registrar;
  private final ImageCropperDelegate delegate;
  private Application.ActivityLifecycleCallbacks activityLifecycleCallbacks;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);

    final ImageCropperCache cache = new ImageCropperCache(registrar.activity());
    final ImageCropperDelegate delegate = new ImageCropperDelegate(registrar.activity(), cache);
    registrar.addActivityResultListener(delegate);

    channel.setMethodCallHandler(new ImageCropperPlugin(registrar, delegate));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (registrar.activity() == null) {
      result.error("no_activity", "image_cropper plugin requires a foreground activity.", null);
      return;
    }
    if (call.method.equals("cropImage")) {
      delegate.startCrop(call, result);
    }
  }

  ImageCropperPlugin(final Registrar registrar, final ImageCropperDelegate delegate) {
    this.registrar = registrar;
    this.delegate = delegate;

    this.activityLifecycleCallbacks =
            new Application.ActivityLifecycleCallbacks() {
              @Override
              public void onActivityCreated(Activity activity, Bundle savedInstanceState) {}

              @Override
              public void onActivityStarted(Activity activity) {}

              @Override
              public void onActivityResumed(Activity activity) {}

              @Override
              public void onActivityPaused(Activity activity) {}

              @Override
              public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                if (activity == registrar.activity()) {
                  delegate.saveStateBeforeResult();
                }
              }

              @Override
              public void onActivityDestroyed(Activity activity) {
                if (activity == registrar.activity()
                        && registrar.activity().getApplicationContext() != null) {
                  ((Application) registrar.activity().getApplicationContext())
                          .unregisterActivityLifecycleCallbacks(
                                  this); // Use getApplicationContext() to avoid casting failures
                }
              }

              @Override
              public void onActivityStopped(Activity activity) {}
            };

    if (this.registrar != null
            && this.registrar.context() != null
            && this.registrar.context().getApplicationContext() != null) {
      ((Application) this.registrar.context().getApplicationContext())
              .registerActivityLifecycleCallbacks(
                      this
                              .activityLifecycleCallbacks); // Use getApplicationContext() to avoid casting failures.
    }
  }
}
