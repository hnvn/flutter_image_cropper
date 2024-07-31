# Image Cropper

[![pub package](https://img.shields.io/pub/v/image_cropper.svg)](https://pub.dartlang.org/packages/image_cropper)


A Flutter plugin for Android, iOS and Web supports cropping images. This plugin is based on three different native libraries so it comes with different UI between these platforms.

## Introduction

**Image Cropper** doesn't manipulate images in Dart codes directly, instead, the plugin uses [Platform Channel](https://flutter.dev/docs/development/platform-integration/platform-channels) to expose Dart APIs that Flutter application can use to communicate with three very powerful native libraries ([uCrop](https://github.com/Yalantis/uCrop), [TOCropViewController](https://github.com/TimOliver/TOCropViewController) and [Cropper.js](https://github.com/fengyuanchen/cropperjs)) to crop and rotate images. Because of that, all credits belong to these libraries.

### uCrop - Yalantis 
[![GitHub watchers](https://img.shields.io/github/watchers/Yalantis/uCrop.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/watchers/)  [![GitHub stars](https://img.shields.io/github/stars/Yalantis/uCrop.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/stargazers/)  [![GitHub forks](https://img.shields.io/github/forks/Yalantis/uCrop.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/network/) [![](https://jitpack.io/v/Yalantis/uCrop.svg)](https://jitpack.io/#Yalantis/uCrop) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This project aims to provide an ultimate and flexible image cropping experience. Made in [Yalantis](https://yalantis.com/?utm_source=github)

<p align="center">
	<img src="https://github.com/hnvn/flutter_image_cropper/blob/master/image_cropper/screenshots/cropper_android.gif?raw=true" width="200"  />
</p>

### TOCropViewController - Tim Oliver
[![GitHub watchers](https://img.shields.io/github/watchers/TimOliver/TOCropViewController.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/watchers/)  [![GitHub stars](https://img.shields.io/github/stars/TimOliver/TOCropViewController.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/stargazers/)  [![GitHub forks](https://img.shields.io/github/forks/TimOliver/TOCropViewController.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/network/) [![Version](https://img.shields.io/cocoapods/v/TOCropViewController.svg?style=flat)](https://cocoadocs.org/docsets/TOCropViewController) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/TimOliver/TOCropViewController/master/LICENSE)

`TOCropViewController` is an open-source `UIViewController` subclass to crop out sections of `UIImage` objects, as well as perform basic rotations. It is excellent for things like editing profile pictures, or sharing parts of a photo online. It has been designed with the iOS Photos app editor in mind, and as such, behaves in a way that should already feel familiar to users of iOS.

<p align="center">
  <img src="https://github.com/hnvn/flutter_image_cropper/blob/master/image_cropper/screenshots/cropper_ios.gif?raw=true" width="200" />
</p>

### Cropper.js - Fengyuan Chen 
[![GitHub watchers](https://img.shields.io/github/watchers/fengyuanchen/cropperjs.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/fengyuanchen/cropperjs/watchers/) [![GitHub stars](https://img.shields.io/github/stars/fengyuanchen/cropperjs.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/fengyuanchen/cropperjs/stargazers/) [![GitHub forks](https://img.shields.io/github/forks/fengyuanchen/cropperjs.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/fengyuanchen/cropperjs/network/) [![npm version](https://badge.fury.io/js/cropperjs.svg)](https://badge.fury.io/js/cropperjs) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/fengyuanchen/cropperjs/master/LICENSE)

JavaScript image cropper.

<p align="center">
  <img src="https://github.com/hnvn/flutter_image_cropper/blob/master/image_cropper/screenshots/cropper_web.png?raw=true" width="400"/>
</p>

## How to install

### Android

- Add UCropActivity into your AndroidManifest.xml

````xml
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
````

#### Note:
From v1.2.0, you need to migrate your android project to v2 embedding ([detail](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects))

### iOS
- No configuration required

### Web
- Add following codes inside `<head>` tag in file `web/index.html`:

```html
<head>
  ....

  <!-- cropperjs -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.2/cropper.css" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.2/cropper.min.js"></script>

  ....
</head>
```

## Usage

### Required parameters

* **sourcePath**: the absolute path of an image file.

### Optional parameters

* **maxWidth**: maximum cropped image width.

* **maxHeight**: maximum cropped image height.

* **aspectRatio**: controls the aspect ratio of crop bounds. If this values is set, the cropper is locked and user can't change the aspect ratio of crop bounds.

* **compressFormat**: the format of result image, png or jpg (default is ImageCompressFormat.jpg).

* **compressQuality**: number between 0 and 100 to control the quality of image compression. Note: this field is ignored on Web.

* **uiSettings**: controls UI customization on specific platform (android, ios, web,...)

  * Android: see [Android customization](#android-1).

  * iOS: see [iOS customization](#ios-1).

  * Web: see [Web customization](#web-1).

### Note

* The result file is saved in `NSTemporaryDirectory` on iOS and application Cache directory on Android, so it can be lost later, you are responsible for storing it somewhere permanent (if needed).

* The implementation on Web is much different compared to the implementation on mobile app. It causes some configuration fields not working (`compressQuality`) on Web.

* `WebUiSettings` is required for Web.

## Customization

### Android

<details>
<summary>Click to view detail</summary>
<br/>

**Image Cropper** provides a helper class called `AndroidUiSettings` that wraps all properties can be used to customize UI in **uCrop** library. 

| Property                    | Description                                                                                                | Type                            |
| --------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `toolbarTitle`              | desired text for Toolbar title                                                                             | String                          |
| `toolbarColor`              | desired color of the Toolbar                                                                               | Color                           |
| `statusBarColor`            | desired color of status                                                                                    | Color                           |
| `toolbarWidgetColor`        | desired color of Toolbar text and buttons (default is darker orange)                                       | Color                           |
| `backgroundColor`           | desired background color that should be applied to the root view                                           | Color                           |
| `activeControlsWidgetColor` | desired resolved color of the active and selected widget and progress wheel middle line (default is white) | Color                           |
| `dimmedLayerColor`          | desired color of dimmed area around the crop bounds                                                        | Color                           |
| `cropFrameColor`            | desired color of crop frame                                                                                | Color                           |
| `cropGridColor`             | desired color of crop grid/guidelines                                                                      | Color                           |
| `cropFrameStrokeWidth`      | desired width of crop frame line in pixels                                                                 | int                             |
| `cropGridRowCount`          | crop grid rows count                                                                                       | int                             |
| `cropGridColumnCount`       | crop grid columns count                                                                                    | int                             |
| `cropGridStrokeWidth`       | desired width of crop grid lines in pixels                                                                 | int                             |
| `showCropGrid`              | set to true if you want to see a crop grid/guidelines on top of an image                                   | bool                            |
| `lockAspectRatio`           | set to true if you want to lock the aspect ratio of crop bounds with a fixed value (locked by default)     | bool                            |
| `hideBottomControls`        | set to true to hide the bottom controls (shown by default)                                                 | bool                            |
| `initAspectRatio`           | desired aspect ratio is applied (from the list of given aspect ratio presets) when starting the cropper    | CropAspectRatioPreset           |
| `cropStyle`                 | controls the style of crop bounds, it can be rectangle or circle style (default is `CropStyle.rectangle`). | CropStyle                       |
| `aspectRatioPresets`        | controls the list of aspect ratios in the crop menu view.                                                  | List<CropAspectRatioPresetData> |

</details>

### iOS

<details>
<summary>Click to view detail</summary>
<br/>

**Image Cropper** provides a helper class called `IOUiSettings` that wraps all properties can be used to customize UI in **TOCropViewController** library. 

| Property                              | Description                                                                                                                                                                                                                                                                                                                                 | Type                            |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `minimumAspectRatio`                  | The minimum croping aspect ratio. If set, user is prevented from setting cropping rectangle to lower aspect ratio than defined by the parameter                                                                                                                                                                                             | double                          |
| `rectX`                               | The initial rect of cropping: x.                                                                                                                                                                                                                                                                                                            | double                          |
| `rectY`                               | The initial rect of cropping: y.                                                                                                                                                                                                                                                                                                            | double                          |
| `rectWidth`                           | The initial rect of cropping: width.                                                                                                                                                                                                                                                                                                        | double                          |
| `rectHeight`                          | The initial rect of cropping: height.                                                                                                                                                                                                                                                                                                       | double                          |
| `showActivitySheetOnDone`             | If true, when the user hits 'Done', a `UIActivityController` will appear before the view controller ends                                                                                                                                                                                                                                    | bool                            |
| `showCancelConfirmationDialog`        | Shows a confirmation dialog when the user hits 'Cancel' and there are pending changes (default is false)                                                                                                                                                                                                                                    | bool                            |
| `rotateClockwiseButtonHidden`         | When disabled, an additional rotation button that rotates the canvas in 90-degree segments in a clockwise direction is shown in the toolbar (default is false)                                                                                                                                                                              | bool                            |
| `embedInNavigationController`                  | Embed the presented TOCropViewController in a UINavigationController. (default is false)                                                                                                                             | bool                            |
| `hidesNavigationBar`                  | If this controller is embedded in `UINavigationController` its navigation bar is hidden by default. Set this property to false to show the navigation bar. This must be set before this controller is presented                                                                                                                             | bool                            |
| `rotateButtonsHidden`                 | When enabled, hides the rotation button, as well as the alternative rotation button visible when `showClockwiseRotationButton` is set to YES (default is false)                                                                                                                                                                             | bool                            |
| `resetButtonHidden`                   | When enabled, hides the 'Reset' button on the toolbar (default is false)                                                                                                                                                                                                                                                                    | bool                            |
| `aspectRatioPickerButtonHidden`       | When enabled, hides the 'Aspect Ratio Picker' button on the toolbar (default is false)                                                                                                                                                                                                                                                      | bool                            |
| `resetAspectRatioEnabled`             | If true, tapping the reset button will also reset the aspect ratio back to the image default ratio. Otherwise, the reset will just zoom out to the current aspect ratio. If this is set to false, and `aspectRatioLockEnabled` is set to true, then the aspect ratio button will automatically be hidden from the toolbar (default is true) | bool                            |
| `aspectRatioLockDimensionSwapEnabled` | If true, a custom aspect ratio is set, and the `aspectRatioLockEnabled` is set to true, the crop box will swap it's dimensions depending on portrait or landscape sized images. This value also controls whether the dimensions can swap when the image is rotated (default is false)                                                       | bool                            |
| `aspectRatioLockEnabled`              | If true, while it can still be resized, the crop box will be locked to its current aspect ratio. If this is set to true, and `resetAspectRatioEnabled` is set to false, then the aspect ratio button will automatically be hidden from the toolbar (default is false)                                                                       | bool                            |
| `title`                               | Title text that appears at the top of the view controller.                                                                                                                                                                                                                                                                                  | String                          |
| `doneButtonTitle`                     | Title for the 'Done' button. Setting this will override the Default which is a localized string for "Done"                                                                                                                                                                                                                                  | String                          |
| `cancelButtonTitle`                   | Title for the 'Cancel' button. Setting this will override the Default which is a localized string for "Cancel"                                                                                                                                                                                                                              | String                          |
| `cropStyle`                           | controls the style of crop bounds, it can be rectangle or circle style (default is `CropStyle.rectangle`).                                                                                                                                                                                                                                  | CropStyle                       |
| `aspectRatioPresets`                  | controls the list of aspect ratios in the crop menu view.                                                                                                                                                                                                                                                                                   | List<CropAspectRatioPresetData> |

</details>

### Web

<details>
<summary>Click to view detail</summary>
<br/>

**Image Cropper** provides a helper class called `WebUiSettings` that wraps all properties can be used to customize UI in **cropperjs** library. 

| Property                   | Description                                                                                                                                                                                                                       | Type             |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `size`                     | Display size of the cropper. Default = `{ width: 500, height: 500 }`                                                                                                                                                              | CropperSize      |
| `viewwMode`                | Define the view mode of the cropper. Details of available options in [View Mode](#view-mode). Default = `0`                                                                                                                       | WebViewMode      |
| `dragMode`                 | Define the dragging mode of the cropper. Details of available options in [Drag Mode](#drag-mode). Default = `crop`                                                                                                                | WebDragMode      |
| `initialAspectRatio`       | Define the initial aspect ratio of the crop box. By default, it is the same as the aspect ratio of the canvas (image wrapper).  Note: Only available when the aspectRatio option is set to NaN.                                   | num              |
| `checkCrossOrigin`         | Check if the current image is a cross-origin. Default = `true` image.                                                                                                                                                             | bool             |
| `checkOrientation`         | Check the current image's Exif Orientation information. Note that only a JPEG image may contain Exif Orientation information.  Requires to set both the rotatable and scalable options to true at the same time. Default = `true` | bool             |
| `modal`                    | Show the black modal above the image and under the crop box. Default = `true`                                                                                                                                                     | bool             |
| `guides`                   | Show the dashed lines above the crop box. Default = `true`                                                                                                                                                                        | bool             |
| `center`                   | Show the center indicator above the crop box. Default = `true`                                                                                                                                                                    | bool             |
| `highlight`                | Show the white modal above the crop box (highlight the crop box). Default = `true`                                                                                                                                                | bool             |
| `background`               | Show the grid background of the container. Default = `true`                                                                                                                                                                       | bool             |
| `movable`                  | Enable to move the image. Default = `true`                                                                                                                                                                                        | bool             |
| `rotatable`                | Enable to rotate the image. Default = `true`                                                                                                                                                                                      | bool             |
| `scalable`                 | Enable to scale the image. Default = `true`                                                                                                                                                                                       | bool             |
| `zoomable`                 | Enable to zoom the image. Default = `true`                                                                                                                                                                                        | bool             |
| `zoomOnTouch`              | Enable to zoom the image by dragging touch. Default = `true`                                                                                                                                                                      | bool             |
| `zoomOnWheel`              | Enable to zoom the image by mouse wheeling. Default = `true`                                                                                                                                                                      | bool             |
| `wheelZoomRatio`           | Define zoom ratio when zooming the image by mouse wheeling. Default = `0.1`                                                                                                                                                       | num              |
| `cropBoxMovable`           | Enable to move the crop box by dragging. Default = `true`                                                                                                                                                                         | bool             |
| `cropBoxResizable`         | Enable to resize the crop box by dragging. Default = `true`                                                                                                                                                                       | bool             |
| `toggleDragModeOnDblclick` | Enable to toggle drag mode between "crop" and "move" when clicking twice on the cropper. Default = `true`                                                                                                                         | bool             |
| `minContainerWidth`        | The minimum width of the container. Default = `200`                                                                                                                                                                               | num              |
| `minContainerHeight`       | The minimum height of the container. Default = `100`                                                                                                                                                                              | num              |
| `minCropBoxWidth`          | The minimum width of the crop box. Default = `0`                                                                                                                                                                                  | num              |
| `minCropBoxHeight`         | The minimum height of the crop box. Default = `0`                                                                                                                                                                                 | num              |
| `presentStyle`             | Presentation style of cropper, either a dialog or a page (route). Default = `dialog`                                                                                                                                              | WebPresentStyle  |
| `context`                  | Current BuildContext. The context is required to show cropper dialog or route                                                                                                                                                     | BuildContext     |
| `customDialogBuilder`      | Builder to customize the cropper `Dialog`                                                                                                                                                                                         | WebDialogBuilder |
| `customRouteBuilder`       | Builder to customize the cropper `PageRoute`                                                                                                                                                                                      | WebRouteBuilder  |
| `barrierColor`             | Barrier color for displayed `Dialog`                                                                                                                                                                                              | Color            |
| `translations`             | Translations to display                                                                                                                                                                                                           | WebTranslations  |
| `themeData`                | Control UI customization                                                                                                                                                                                                          | WebThemeData     |


#### View Mode:

- `0`: no restrictions
- `1`: restrict the crop box not to exceed the size of the canvas.
- `2`: restrict the minimum canvas size to fit within the container. If the proportions of the canvas and the container differ, the minimum canvas will be surrounded by extra space in one of the dimensions.
- `3`: restrict the minimum canvas size to fill fit the container. If the proportions of the canvas and the container are different, the container will not be able to fit the whole canvas in one of the dimensions.

If you set `viewMode` to `0`, the crop box can extend outside the canvas, while a value of `1`, `2`, or `3` will restrict the crop box to the size of the canvas. `viewMode` of `2` or `3` will additionally restrict the canvas to the container. There is no difference between `2` and `3` when the proportions of the canvas and the container are the same.


#### Drag Mode:

 - `crop`: create a new crop box
 - `move`: move the canvas
 - `none`: do nothing

#### Note:

If using `WebDialogBuilder` and `WebRouteBuilder` to customize cropper dialog and route, the customization codes must to call following functions:
 - `initCropper()` to initialize `Cropper` object.
 - `crop()` to trigger crop feature and then returning the cropped result data to the plugin by using `Navigator.of(context).pop(result)`. 

````dart

  class CropperDialog extends StatefulWidget {
    ...
  }  

  class _CropperDialogState extends State<CropperDialog> {
    @override
    void initState() {
      super.initState();
      /// IMPORTANT: must to call this function
      widget.initCropper();
    }

    @override
    Widget build(BuildContext context) {
      Dialog(
        child: Column(
          children: [
            ...
            cropper,
            ...
            TextButton(
              onPressed: () async {
                /// IMPORTANT: to call crop() function and return
                /// result data to plugin, for example:
                final result = await crop();
                Navigator.of(context).pop(result);
              },
              child: Text('Crop'),
            )
          ]
        ),
      );
    }
  }

  WebUiSettings(
    ...
    customDialogBuilder: (cropper, initCropper, crop, rotate, scale) {
      return CropperDialog(
        cropper: cropper,
        initCropper: initCropper,
        crop: crop,
        rotate: rotate,
        scale: scale,
      );
    },
    ...
  )

````

</details>

## Example

````dart

import 'package:image_cropper/image_cropper.dart';

CroppedFile croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ],
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
        ],
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  );

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
    
````

</details>

## Credits

- Android: [uCrop](https://github.com/Yalantis/uCrop) created by [Yalantis](https://github.com/Yalantis)
- iOS: [TOCropViewController](https://github.com/TimOliver/TOCropViewController) created by [Tim Oliver](https://twitter.com/TimOliverAU)
- Web: [Cropper.js](https://github.com/fengyuanchen/cropperjs) created by [Fengyuan Chen](https://github.com/fengyuanchen)
