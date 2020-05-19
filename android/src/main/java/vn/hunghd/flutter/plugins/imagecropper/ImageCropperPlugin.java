package vn.hunghd.flutter.plugins.imagecropper;


import android.app.Activity;

import androidx.appcompat.app.AppCompatDelegate;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * ImageCropperPlugin
 */
public class ImageCropperPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {
    static {
        AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
    }

    private static final String CHANNEL = "plugins.hunghd.vn/image_cropper";
    private ImageCropperDelegate delegate;

    private ActivityPluginBinding activityPluginBinding;


    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {

        ImageCropperPlugin plugin = new ImageCropperPlugin();

        plugin.setupEngine(registrar.messenger());
        ImageCropperDelegate delegate = plugin.setupActivity(registrar.activity());
        registrar.addActivityResultListener(delegate);

    }

    private void setupEngine(BinaryMessenger messenger) {
        MethodChannel channel = new MethodChannel(messenger, CHANNEL);
        channel.setMethodCallHandler(this);
    }

    public ImageCropperDelegate setupActivity(Activity activity) {
        delegate = new ImageCropperDelegate(activity);
        return delegate;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {

        if (call.method.equals("cropImage")) {
            delegate.startCrop(call, result);
        }

    }
    //////////////////////////////////////////////////////////////////////////////////////

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        setupEngine(flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {

        setupActivity(activityPluginBinding.getActivity());
        this.activityPluginBinding = activityPluginBinding;
        activityPluginBinding.addActivityResultListener(delegate);
    }
    //////////////////////////////////////////////////////////////////////////////////////

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding flutterPluginBinding) {
        // no need to clear channel
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activityPluginBinding.removeActivityResultListener(delegate);
        activityPluginBinding = null;
        delegate = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
        onAttachedToActivity(activityPluginBinding);
    }


}
