#import "./include/image_cropper/FLTImageCropperPlugin.h"
#import "TOCropViewController.h"
#import <TOCropViewController/TOCropViewConstants.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface FLTImageCropperPlugin () <TOCropViewControllerDelegate>
@end

@implementation FLTImageCropperPlugin {
  FlutterResult _result;
  NSDictionary *_arguments;
  float _compressQuality;
  NSString *_compressFormat;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.hunghd.vn/image_cropper"
            binaryMessenger:[registrar messenger]];
  FLTImageCropperPlugin *instance = [[FLTImageCropperPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([@"cropImage" isEqualToString:call.method]) {
    _result = result;
    _arguments = call.arguments;
    NSString *sourcePath = call.arguments[@"source_path"];
    NSNumber *ratioX = call.arguments[@"ratio_x"];
    NSNumber *ratioY = call.arguments[@"ratio_y"];
    NSString *cropStyle = call.arguments[@"ios.crop_style"];
    NSArray *aspectRatioPresets = call.arguments[@"ios.aspect_ratio_presets"];
    NSNumber *compressQuality = call.arguments[@"compress_quality"];
    NSString *compressFormat = call.arguments[@"compress_format"];
    BOOL embedInNavigationController =
        [call.arguments[@"ios.embed_in_navigation_controller"] boolValue];

    UIImage *image = [UIImage imageWithContentsOfFile:sourcePath];

    TOCropViewController *cropViewController;
    if ([@"circle" isEqualToString:cropStyle]) {
      cropViewController = [[TOCropViewController alloc]
          initWithCroppingStyle:TOCropViewCroppingStyleCircular
                          image:image];
    } else {
      cropViewController = [[TOCropViewController alloc] initWithImage:image];
    }

    cropViewController.delegate = self;

    if (compressQuality && [compressQuality isKindOfClass:[NSNumber class]]) {
      _compressQuality = compressQuality.intValue * 1.0f / 100;
    } else {
      _compressQuality = 0.9f;
    }
    if (compressFormat && [compressFormat isKindOfClass:[NSString class]]) {
      _compressFormat = compressFormat;
    } else {
      _compressFormat = @"jpg";
    }

    NSMutableArray *allowedAspectRatios = [NSMutableArray new];
    NSString *customAspectRatioName;
    NSDictionary *customAspectRatioData;
    for (NSDictionary *preset in aspectRatioPresets) {
      if (preset) {
        TOCropViewControllerAspectRatioPreset* presetValue =
            [self parseAspectRatioPresetFromDict:preset];
          [allowedAspectRatios addObject:presetValue];
      }
    }
    cropViewController.allowedAspectRatios = allowedAspectRatios;

    [self setupUiCustomizedOptions:call.arguments
                 forViewController:cropViewController];

    if (ratioX != (id)[NSNull null] && ratioY != (id)[NSNull null]) {
      cropViewController.aspectRatioPreset = CGSizeMake([ratioX floatValue], [ratioY floatValue]);
      cropViewController.resetAspectRatioEnabled = NO;
      cropViewController.aspectRatioPickerButtonHidden = YES;
      cropViewController.aspectRatioLockDimensionSwapEnabled = YES;
      cropViewController.aspectRatioLockEnabled = YES;
    }

    // Find key window (camera is presented here) and Flutter window (cropper must be presented here).
    // In UISceneDelegate apps (Flutter default on iOS 13+), these are two separate windows:
    // - keyWindow: plain UIViewController root, used by iOS for system presentations like camera
    // - flutterWindow: FlutterViewController root, Flutter's actual UI surface
    // Presenting the cropper on keyWindow would make it invisible behind Flutter's window.
    UIWindow *keyWindow = nil;
    UIWindow *flutterWindow = nil;

    if (@available(iOS 13.0, *)) {
      for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] &&
            scene.activationState == UISceneActivationStateForegroundActive) {
          for (UIWindow *w in [(UIWindowScene *)scene windows]) {
            if (w.isKeyWindow) {
              keyWindow = w;
            }
            if ([w.rootViewController isKindOfClass:NSClassFromString(@"FlutterViewController")]) {
              flutterWindow = w;
            }
          }
        }
      }
    }
    if (!keyWindow) {
      keyWindow = [UIApplication sharedApplication].delegate.window;
    }
    // Fall back to keyWindow if no dedicated Flutter window found
    if (!flutterWindow) {
      flutterWindow = keyWindow;
    }

    if (!keyWindow) {
      _result(nil);
      _result = nil;
      _arguments = nil;
      return;
    }

    // Find the VC hosting the camera in keyWindow
    UIViewController *cameraHost = keyWindow.rootViewController;
    while (cameraHost.presentedViewController &&
           !cameraHost.presentedViewController.isBeingDismissed) {
      cameraHost = cameraHost.presentedViewController;
    }

    // Find the topmost VC in Flutter's window to present the cropper on
    UIViewController *flutterTopController = flutterWindow.rootViewController;
    while (flutterTopController.presentedViewController &&
           !flutterTopController.presentedViewController.isBeingDismissed) {
      flutterTopController = flutterTopController.presentedViewController;
    }

    UIViewController *capturedFlutterTop = flutterTopController;

    void (^presentCropper)(void) = ^{
      if (embedInNavigationController) {
        UINavigationController *navigationController =
            [[UINavigationController alloc]
                initWithRootViewController:cropViewController];
        navigationController.modalTransitionStyle =
            cropViewController.modalTransitionStyle;
        navigationController.modalPresentationStyle =
            cropViewController.modalPresentationStyle;
        navigationController.transitioningDelegate =
            cropViewController.transitioningDelegate;
        [capturedFlutterTop presentViewController:navigationController
                                         animated:YES
                                       completion:nil];
      } else {
        [capturedFlutterTop presentViewController:cropViewController
                                         animated:YES
                                       completion:nil];
      }
    };

    // If the camera VC is still mid-dismissal, iOS will silently drop any
    // presentViewController call. Wait for the dismissal to fully complete first.
    if (cameraHost.presentedViewController &&
        cameraHost.presentedViewController.isBeingDismissed) {
      [cameraHost.presentedViewController
          dismissViewControllerAnimated:NO
                             completion:^{
        presentCropper();
      }];
    } else {
      presentCropper();
    }

  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)setupUiCustomizedOptions:(id)options
               forViewController:(TOCropViewController *)controller {
  NSNumber *minimumAspectRatio = options[@"ios.minimum_aspect_ratio"];
  NSNumber *rectX = options[@"ios.rect_x"];
  NSNumber *rectY = options[@"ios.rect_y"];
  NSNumber *rectWidth = options[@"ios.rect_width"];
  NSNumber *rectHeight = options[@"ios.rect_height"];
  NSNumber *showActivitySheetOnDone = options[@"ios.show_activity_sheet_on_done"];
  NSNumber *showCancelConfirmationDialog = options[@"ios.show_cancel_confirmation_dialog"];
  NSNumber *rotateClockwiseButtonHidden = options[@"ios.rotate_clockwise_button_hidden"];
  NSNumber *hidesNavigationBar = options[@"ios.hides_navigation_bar"];
  NSNumber *rotateButtonHidden = options[@"ios.rotate_button_hidden"];
  NSNumber *resetButtonHidden = options[@"ios.reset_button_hidden"];
  NSNumber *aspectRatioPickerButtonHidden = options[@"ios.aspect_ratio_picker_button_hidden"];
  NSNumber *resetAspectRatioEnabled = options[@"ios.reset_aspect_ratio_enabled"];
  NSNumber *aspectRatioLockDimensionSwapEnabled = options[@"ios.aspect_ratio_lock_dimension_swap_enabled"];
  NSNumber *aspectRatioLockEnabled = options[@"ios.aspect_ratio_lock_enabled"];
  NSString *title = options[@"ios.title"];
  NSString *doneButtonTitle = options[@"ios.done_button_title"];
  NSString *cancelButtonTitle = options[@"ios.cancel_button_title"];

  if (minimumAspectRatio && [minimumAspectRatio isKindOfClass:[NSNumber class]]) {
    controller.minimumAspectRatio = minimumAspectRatio.floatValue;
  }
  if (rectX && [rectX isKindOfClass:[NSNumber class]] && rectY &&
      [rectY isKindOfClass:[NSNumber class]] && rectWidth &&
      [rectWidth isKindOfClass:[NSNumber class]] && rectHeight &&
      [rectHeight isKindOfClass:[NSNumber class]]) {
    controller.imageCropFrame = CGRectMake(rectX.floatValue, rectY.floatValue,
                                           rectWidth.floatValue, rectHeight.floatValue);
  }
  if (showActivitySheetOnDone && [showActivitySheetOnDone isKindOfClass:[NSNumber class]]) {
    controller.showActivitySheetOnDone = showActivitySheetOnDone.boolValue;
  }
  if (showCancelConfirmationDialog && [showCancelConfirmationDialog isKindOfClass:[NSNumber class]]) {
    controller.showCancelConfirmationDialog = showCancelConfirmationDialog.boolValue;
  }
  if (rotateClockwiseButtonHidden && [rotateClockwiseButtonHidden isKindOfClass:[NSNumber class]]) {
    controller.rotateClockwiseButtonHidden = rotateClockwiseButtonHidden.boolValue;
  }
  if (hidesNavigationBar && [hidesNavigationBar isKindOfClass:[NSNumber class]]) {
    controller.hidesNavigationBar = hidesNavigationBar.boolValue;
  }
  if (rotateButtonHidden && [rotateButtonHidden isKindOfClass:[NSNumber class]]) {
    controller.rotateButtonsHidden = rotateButtonHidden.boolValue;
  }
  if (resetButtonHidden && [resetButtonHidden isKindOfClass:[NSNumber class]]) {
    controller.resetButtonHidden = resetButtonHidden.boolValue;
  }
  if (aspectRatioPickerButtonHidden && [aspectRatioPickerButtonHidden isKindOfClass:[NSNumber class]]) {
    controller.aspectRatioPickerButtonHidden = aspectRatioPickerButtonHidden.boolValue;
  }
  if (resetAspectRatioEnabled && [resetAspectRatioEnabled isKindOfClass:[NSNumber class]]) {
    controller.resetAspectRatioEnabled = resetAspectRatioEnabled.boolValue;
  }
  if (aspectRatioLockDimensionSwapEnabled && [aspectRatioLockDimensionSwapEnabled isKindOfClass:[NSNumber class]]) {
    controller.aspectRatioLockDimensionSwapEnabled = aspectRatioLockDimensionSwapEnabled.boolValue;
  }
  if (aspectRatioLockEnabled && [aspectRatioLockEnabled isKindOfClass:[NSNumber class]]) {
    controller.aspectRatioLockEnabled = aspectRatioLockEnabled.boolValue;
  }
  if (title && [title isKindOfClass:[NSString class]]) {
    controller.title = title;
  }
  if (doneButtonTitle && [doneButtonTitle isKindOfClass:[NSString class]]) {
    controller.doneButtonTitle = doneButtonTitle;
  }
  if (cancelButtonTitle && [cancelButtonTitle isKindOfClass:[NSString class]]) {
    controller.cancelButtonTitle = cancelButtonTitle;
  }
}

- (TOCropViewControllerAspectRatioPreset*)parseAspectRatioPresetFromDict:(NSDictionary *)dict {
  NSString *name = dict[@"name"];
  NSDictionary *ratioData = dict[@"data"];
  TOCropViewControllerAspectRatioPreset *object = [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeZero title:@"Original"];
  NSBundle *resourceBundle = TO_CROP_VIEW_RESOURCE_BUNDLE_FOR_OBJECT(object);
  if ([@"square" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake(1.0f, 1.0f)
                                                                 title:NSLocalizedStringFromTableInBundle(@"Square", @"TOCropViewControllerLocalizable", resourceBundle, nil)];
  } else if ([@"original" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeZero
                                                                 title:NSLocalizedStringFromTableInBundle(@"Original", @"TOCropViewControllerLocalizable", resourceBundle, nil)];
  } else if ([@"3x2" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake(3.0f, 2.0f)
                                                                 title:@"3:2"];
  } else if ([@"4x3" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake(4.0f, 3.0f)
                                                                 title:@"4:3"];
  } else if ([@"5x3" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake(5.0f, 3.0f)
                                                                 title:@"5:3"];
  } else if ([@"5x4" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake(5.0f, 4.0f)
                                                                 title:@"5:4"];
  } else if ([@"7x5" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake(7.0f, 5.0f)
                                                                 title:@"7:5"];
  } else if ([@"16x9" isEqualToString:name]) {
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake(16.0f, 9.0f)
                                                                 title:@"16:9"];
  } else {
      NSNumber *ratioX = ratioData[@"ratio_x"];
      NSNumber *ratioY = ratioData[@"ratio_y"];
    return [[TOCropViewControllerAspectRatioPreset alloc] initWithSize:CGSizeMake([ratioX floatValue], [ratioY floatValue])
                                                                 title:name];
  }
}

#pragma TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController
            didCropToImage:(UIImage *)image
                  withRect:(CGRect)cropRect
                     angle:(NSInteger)angle {
  image = [self normalizedImage:image];

  NSNumber *maxWidth = [_arguments objectForKey:@"max_width"];
  NSNumber *maxHeight = [_arguments objectForKey:@"max_height"];

  if (maxWidth != (id)[NSNull null] && maxHeight != (id)[NSNull null]) {
    image = [self scaledImage:image maxWidth:maxWidth maxHeight:maxHeight];
  }

  NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
  NSData *data;
  NSString *tmpFile;

  if ([@"png" isEqualToString:_compressFormat]) {
    data = UIImagePNGRepresentation(image);
    tmpFile = [NSString stringWithFormat:@"image_cropper_%@.png", guid];
  } else {
    data = UIImageJPEGRepresentation(image, _compressQuality);
    tmpFile = [NSString stringWithFormat:@"image_cropper_%@.jpg", guid];
  }

  NSString *tmpDirectory = NSTemporaryDirectory();
  NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];

  if (_result) {
    if ([[NSFileManager defaultManager] createFileAtPath:tmpPath contents:data attributes:nil]) {
      _result(tmpPath);
    } else {
      _result([FlutterError errorWithCode:@"create_error"
                                  message:@"Temporary file could not be created"
                                  details:nil]);
    }
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    _result = nil;
    _arguments = nil;
  }
}

- (void)cropViewController:(TOCropViewController *)cropViewController
        didFinishCancelled:(BOOL)cancelled {
  [cropViewController dismissViewControllerAnimated:YES completion:nil];
  _result(nil);
  _result = nil;
  _arguments = nil;
}

- (UIImage *)normalizedImage:(UIImage *)image {
  if (image.imageOrientation == UIImageOrientationUp) return image;
  UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
  [image drawInRect:(CGRect){0, 0, image.size}];
  UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return normalizedImage;
}

- (UIImage *)scaledImage:(UIImage *)image
                maxWidth:(NSNumber *)maxWidth
               maxHeight:(NSNumber *)maxHeight {
  double originalWidth = image.size.width;
  double originalHeight = image.size.height;

  bool hasMaxWidth = maxWidth != (id)[NSNull null];
  bool hasMaxHeight = maxHeight != (id)[NSNull null];

  double width = hasMaxWidth ? MIN([maxWidth doubleValue], originalWidth) : originalWidth;
  double height = hasMaxHeight ? MIN([maxHeight doubleValue], originalHeight) : originalHeight;

  bool shouldDownscaleWidth = hasMaxWidth && [maxWidth doubleValue] < originalWidth;
  bool shouldDownscaleHeight = hasMaxHeight && [maxHeight doubleValue] < originalHeight;
  bool shouldDownscale = shouldDownscaleWidth || shouldDownscaleHeight;

  if (shouldDownscale) {
    double downscaledWidth = (height / originalHeight) * originalWidth;
    double downscaledHeight = (width / originalWidth) * originalHeight;

    if (width < height) {
      if (!hasMaxWidth) { width = downscaledWidth; } else { height = downscaledHeight; }
    } else if (height < width) {
      if (!hasMaxHeight) { height = downscaledHeight; } else { width = downscaledWidth; }
    } else {
      if (originalWidth < originalHeight) { width = downscaledWidth; }
      else if (originalHeight < originalWidth) { height = downscaledHeight; }
    }
  }

  UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1.0);
  [image drawInRect:CGRectMake(0, 0, width, height)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}

@end
