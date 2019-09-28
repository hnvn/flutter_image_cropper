#import "ImageCropperPlugin.h"
#import <TOCropViewController/TOCropViewController.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

@interface FLTImageCropperPlugin() <TOCropViewControllerDelegate>
@end

@implementation FLTImageCropperPlugin {
    FlutterResult _result;
    NSDictionary *_arguments;
    UIViewController *_viewController;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.hunghd.vn/image_cropper"
            binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FLTImageCropperPlugin* instance = [[FLTImageCropperPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"cropImage" isEqualToString:call.method]) {
      _result = result;
      _arguments = call.arguments;
      NSString *sourcePath = call.arguments[@"source_path"];
      NSNumber *ratioX = call.arguments[@"ratio_x"];
      NSNumber *ratioY = call.arguments[@"ratio_y"];
      Boolean circleShape = [call.arguments[@"circle_shape"] boolValue];
      NSArray *aspectRatioPresets = call.arguments[@"aspect_ratio_presets"];
      
      UIImage *image = [UIImage imageWithContentsOfFile:sourcePath];
      TOCropViewController *cropViewController;
      cropViewController.delegate = self;
      
      if (circleShape) {
        cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
      } else {
        cropViewController = [[TOCropViewController alloc] initWithImage:image];
      }
      
      NSMutableArray *allowedAspectRatios = [NSMutableArray new];
      for (NSString *preset in aspectRatioPresets) {
          if (preset) {
              [allowedAspectRatios addObject:@([self parseAspectRatioPresetFromName:preset])];
          }
      }
      cropViewController.allowedAspectRatios = allowedAspectRatios;
      
      if (ratioX != (id)[NSNull null] && ratioY != (id)[NSNull null]) {
          cropViewController.customAspectRatio = CGSizeMake([ratioX floatValue], [ratioY floatValue]);
          cropViewController.resetAspectRatioEnabled = NO;
          cropViewController.aspectRatioPickerButtonHidden = YES;
          cropViewController.aspectRatioLockDimensionSwapEnabled = YES;
          cropViewController.aspectRatioLockEnabled = YES;
      }
      [_viewController presentViewController:cropViewController animated:YES completion:nil];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (TOCropViewControllerAspectRatioPreset)parseAspectRatioPresetFromName:(NSString*)name {
    if ([@"square" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPresetSquare;
    } else if ([@"original" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPresetOriginal;
    } else if ([@"3x2" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPreset3x2;
    } else if ([@"4x3" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPreset4x3;
    } else if ([@"5x3" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPreset5x3;
    } else if ([@"5x4" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPreset5x4;
    } else if ([@"7x5" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPreset7x5;
    } else if ([@"16x9" isEqualToString:name]) {
        return TOCropViewControllerAspectRatioPreset16x9;
    } else {
        return TOCropViewControllerAspectRatioPresetOriginal;
    }
}

# pragma TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    image = [self normalizedImage:image];
    
    NSNumber *maxWidth = [_arguments objectForKey:@"max_width"];
    NSNumber *maxHeight = [_arguments objectForKey:@"max_height"];
    
    if (maxWidth != (id)[NSNull null] && maxHeight != (id)[NSNull null]) {
        image = [self scaledImage:image maxWidth:maxWidth maxHeight:maxHeight];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *tmpFile = [NSString stringWithFormat:@"image_cropper_%@.jpg", guid];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];
    
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

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    _result(nil);
    
    _result = nil;
    _arguments = nil;
}

// The way we save images to the tmp dir currently throws away all EXIF data
// (including the orientation of the image). That means, pics taken in portrait
// will not be orientated correctly as is. To avoid that, we rotate the actual
// image data.
// TODO(goderbauer): investigate how to preserve EXIF data.
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
            if (!hasMaxWidth) {
                width = downscaledWidth;
            } else {
                height = downscaledHeight;
            }
        } else if (height < width) {
            if (!hasMaxHeight) {
                height = downscaledHeight;
            } else {
                width = downscaledWidth;
            }
        } else {
            if (originalWidth < originalHeight) {
                width = downscaledWidth;
            } else if (originalHeight < originalWidth) {
                height = downscaledHeight;
            }
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
