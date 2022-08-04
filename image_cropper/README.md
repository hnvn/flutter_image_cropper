# Image Cropper

[![pub package](https://img.shields.io/pub/v/image_cropper.svg)](https://pub.dartlang.org/packages/image_cropper)


A Flutter plugin for Android, iOS and Web supports cropping images. This plugin is based on three different native libraries so it comes with different UI between these platforms.

## Introduction

**Image Cropper** doesn't manipulate images in Dart codes directly, instead, the plugin uses [Platform Channel](https://flutter.dev/docs/development/platform-integration/platform-channels) to expose Dart APIs that Flutter application can use to communicate with three very powerful native libraries ([uCrop](https://github.com/Yalantis/uCrop), [TOCropViewController](https://github.com/TimOliver/TOCropViewController) and [croppie](https://github.com/Foliotek/Croppie)) to crop and rotate images. Because of that, all credits belong to these libraries.

### uCrop - Yalantis 
[![GitHub watchers](https://img.shields.io/github/watchers/Yalantis/uCrop.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/watchers/)  [![GitHub stars](https://img.shields.io/github/stars/Yalantis/uCrop.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/stargazers/)  [![GitHub forks](https://img.shields.io/github/forks/Yalantis/uCrop.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/network/) [![](https://jitpack.io/v/Yalantis/uCrop.svg)](https://jitpack.io/#Yalantis/uCrop) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This project aims to provide an ultimate and flexible image cropping experience. Made in [Yalantis](https://yalantis.com/?utm_source=github)

<p align="center">
	<img src="https://github.com/hnvn/flutter_image_cropper/blob/v2/image_cropper/screenshots/android_demo.gif?raw=true" width="200"  />
</p>

### TOCropViewController - TimOliver
[![GitHub watchers](https://img.shields.io/github/watchers/TimOliver/TOCropViewController.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/watchers/)  [![GitHub stars](https://img.shields.io/github/stars/TimOliver/TOCropViewController.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/stargazers/)  [![GitHub forks](https://img.shields.io/github/forks/TimOliver/TOCropViewController.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/network/) [![Version](https://img.shields.io/cocoapods/v/TOCropViewController.svg?style=flat)](http://cocoadocs.org/docsets/TOCropViewController) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/TimOliver/TOCropViewController/master/LICENSE)

`TOCropViewController` is an open-source `UIViewController` subclass to crop out sections of `UIImage` objects, as well as perform basic rotations. It is excellent for things like editing profile pictures, or sharing parts of a photo online. It has been designed with the iOS Photos app editor in mind, and as such, behaves in a way that should already feel familiar to users of iOS.

<p align="center">
  <img src="https://github.com/hnvn/flutter_image_cropper/blob/v2/image_cropper/screenshots/ios_demo.gif?raw=true" width="200" />
</p>

### Croppie - Foliotek 
[![GitHub watchers](https://img.shields.io/github/watchers/foliotek/croppie.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/foliotek/croppie/watchers/) [![GitHub stars](https://img.shields.io/github/stars/foliotek/croppie.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/foliotek/croppie/stargazers/) [![GitHub forks](https://img.shields.io/github/forks/foliotek/croppie.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/foliotek/croppie/network/) [![npm version](https://badge.fury.io/js/croppie.svg)](https://badge.fury.io/js/croppie) 

Croppie is a fast, easy to use image cropping plugin with tons of configuration options!

<p align="center">
  <img src="https://github.com/hnvn/flutter_image_cropper/blob/v2/image_cropper/screenshots/croppie_preview.png?raw=true" width="400"/>
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

  <!-- Croppie -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.css" />
  <script defer src="https://cdnjs.cloudflare.com/ajax/libs/exif-js/2.3.0/exif.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.js"></script>

  ....
</head>
```

## Usage

### Required parameters

* **sourcePath**: the absolute path of an image file.

### Optional parameters

* **maxWidth**: maximum cropped image width. Note: this field is ignored on Web.

* **maxHeight**: maximum cropped image height. Note: this field is ignored on Web.

* **aspectRatio**: controls the aspect ratio of crop bounds. If this values is set, the cropper is locked and user can't change the aspect ratio of crop bounds. Note: this field is ignored on Web.

* **aspectRatioPresets**: controls the list of aspect ratios in the crop menu view. In Android, you can set the initialized aspect ratio when starting the cropper by setting the value of `AndroidUiSettings.initAspectRatio`. Note: this field is ignored on Web.

* **cropStyle**: controls the style of crop bounds, it can be rectangle or circle style (default is `CropStyle.rectangle`). Note: this field can be overrided by `WebUiSettings.viewPort.type` on Web

* **compressFormat**: the format of result image, png or jpg (default is ImageCompressFormat.jpg).

* **compressQuality**: number between 0 and 100 to control the quality of image compression.

* **uiSettings**: controls UI customization on specific platform (android, ios, web,...)

  * Android: see [Android customization](#android-1).

  * iOS: see [iOS customization](#ios-1).

  * Web: see [Web customization](#web-1).

### Note

* The result file is saved in `NSTemporaryDirectory` on iOS and application Cache directory on Android, so it can be lost later, you are responsible for storing it somewhere permanent (if needed).

* The implementation on Web is much different compared to the implementation on mobile app. It causes some configuration fields not working (`maxWidth`, `maxHeight`, `aspectRatio`, `aspectRatioPresets`) on Web.

* `WebUiSettings` is required for Web.

## Customization

### Android

<details>
<summary>Click to view detail</summary>
<br/>

**Image Cropper** provides a helper class called `AndroidUiSettings` that wraps all properties can be used to customize UI in **uCrop** library. 

| Property                    | Description                                                                                                 | Type                  |
|-----------------------------|-------------------------------------------------------------------------------------------------------------|-----------------------|
| `toolbarTitle`              | desired text for Toolbar title                                                                              | String                |
| `toolbarColor`              | desired color of the Toolbar                                                                                | Color                 |
| `statusBarColor`            | desired color of status                                                                                     | Color                 |
| `toolbarWidgetColor`        | desired color of Toolbar text and buttons (default is darker orange)                                        | Color                 |
| `backgroundColor`           | desired background color that should be applied to the root view                                            | Color                 |
| `activeControlsWidgetColor` | desired resolved color of the active and selected widget and progress wheel middle line (default is white)  | Color                 |
| `dimmedLayerColor`          | desired color of dimmed area around the crop bounds                                                         | Color                 |
| `cropFrameColor`            | desired color of crop frame                                                                                 | Color                 |
| `cropGridColor`             | desired color of crop grid/guidelines                                                                       | Color                 |
| `cropFrameStrokeWidth`      | desired width of crop frame line in pixels                                                                  | int                   |
| `cropGridRowCount`          | crop grid rows count                                                                                        | int                   |
| `cropGridColumnCount`       | crop grid columns count                                                                                     | int                   |
| `cropGridStrokeWidth`       | desired width of crop grid lines in pixels                                                                  | int                   |
| `showCropGrid`              | set to true if you want to see a crop grid/guidelines on top of an image                                    | bool                  |
| `lockAspectRatio`           | set to true if you want to lock the aspect ratio of crop bounds with a fixed value (locked by default)      | bool                  |
| `hideBottomControls`        | set to true to hide the bottom controls (shown by default)                                                  | bool                  |
| `initAspectRatio`           | desired aspect ratio is applied (from the list of given aspect ratio presets) when starting the cropper     | CropAspectRatioPreset |

</details>

### iOS

<details>
<summary>Click to view detail</summary>
<br/>

**Image Cropper** provides a helper class called `IOUiSettings` that wraps all properties can be used to customize UI in **TOCropViewController** library. 

| Property                              | Description                                                                                                                                                                                                                                                                                                                                 | Type   |
|---------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| `minimumAspectRatio`                  | The minimum croping aspect ratio. If set, user is prevented from setting cropping rectangle to lower aspect ratio than defined by the parameter                                                                                                                                                                                             | double |
| `rectX`                               | The initial rect of cropping: x.                                                                                                                                                                                                                                                                                                            | double |
| `rectY`                               | The initial rect of cropping: y.                                                                                                                                                                                                                                                                                                            | double |
| `rectWidth`                           | The initial rect of cropping: width.                                                                                                                                                                                                                                                                                                        | double |
| `rectHeight`                          | The initial rect of cropping: height.                                                                                                                                                                                                                                                                                                       | double |
| `showActivitySheetOnDone`             | If true, when the user hits 'Done', a `UIActivityController` will appear before the view controller ends                                                                                                                                                                                                                                    | bool   |
| `showCancelConfirmationDialog`        | Shows a confirmation dialog when the user hits 'Cancel' and there are pending changes (default is false)                                                                                                                                                                                                                                    | bool   |
| `rotateClockwiseButtonHidden`         | When disabled, an additional rotation button that rotates the canvas in 90-degree segments in a clockwise direction is shown in the toolbar (default is false)                                                                                                                                                                              | bool   |
| `hidesNavigationBar`                  | If this controller is embedded in `UINavigationController` its navigation bar is hidden by default. Set this property to false to show the navigation bar. This must be set before this controller is presented                                                                                                                             | bool   |
| `rotateButtonsHidden`                 | When enabled, hides the rotation button, as well as the alternative rotation button visible when `showClockwiseRotationButton` is set to YES (default is false)                                                                                                                                                                             | bool   |
| `resetButtonHidden`                   | When enabled, hides the 'Reset' button on the toolbar (default is false)                                                                                                                                                                                                                                                                    | bool   |
| `aspectRatioPickerButtonHidden`       | When enabled, hides the 'Aspect Ratio Picker' button on the toolbar (default is false)                                                                                                                                                                                                                                                      | bool   |
| `resetAspectRatioEnabled`             | If true, tapping the reset button will also reset the aspect ratio back to the image default ratio. Otherwise, the reset will just zoom out to the current aspect ratio. If this is set to false, and `aspectRatioLockEnabled` is set to true, then the aspect ratio button will automatically be hidden from the toolbar (default is true) | bool   |
| `aspectRatioLockDimensionSwapEnabled` | If true, a custom aspect ratio is set, and the `aspectRatioLockEnabled` is set to true, the crop box will swap it's dimensions depending on portrait or landscape sized images. This value also controls whether the dimensions can swap when the image is rotated (default is false)                                                       | bool   |
| `aspectRatioLockEnabled`              | If true, while it can still be resized, the crop box will be locked to its current aspect ratio. If this is set to true, and `resetAspectRatioEnabled` is set to false, then the aspect ratio button will automatically be hidden from the toolbar (default is false)                                                                       | bool   |
| `title`                               | Title text that appears at the top of the view controller.                                                                                                                                                                                                                                                                                  | String |
| `doneButtonTitle`                     | Title for the 'Done' button. Setting this will override the Default which is a localized string for "Done"                                                                                                                                                                                                                                  | String |
| `cancelButtonTitle`                   | Title for the 'Cancel' button. Setting this will override the Default which is a localized string for "Cancel"                                                                                                                                                                                                                              | String |

</details>

### Web

<details>
<summary>Click to view detail</summary>
<br/>

**Image Cropper** provides a helper class called `WebUiSettings` that wraps all properties can be used to customize UI in **croppie** library. 

| Property              | Description                                                                                                                                                                                                       | Type                 |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------|
| `boundary`            | The outer container of the cropper. Default = { width: 500, height: 500 }                                                                                                                                         | Boundary             |
| `viewPort`            | The inner container of the coppie. The visible part of the image. Valid type values:'square' 'circle'. Default = { width: 400, height: 400, type: 'square' }                                                      | ViewPort             |
| `customClass`         | A class of your choosing to add to the container to add custom styles to your croppie. Default = ''                                                                                                               | String               |
| `enableExif`          | Enable exif orientation reading. Tells Croppie to read exif orientation from the image data and orient the image correctly before rendering to the page. Requires exif.js (packages/croppie_dart/lib/src/exif.js) | bool                 |
| `enableOrientation`   | Enable or disable support for specifying a custom orientation when binding images. Default = true                                                                                                                | bool                 |
| `enableZoom`          | Enable zooming functionality. If set to false - scrolling and pinching would not zoom. Default = false                                                                                                            | bool                 |
| `enableResize`        | Enable or disable support for resizing the viewport area. Default = false                                                                                                                                         | bool                 |
| `mouseWheelZoom`      | Enable or disable the ability to use the mouse wheel to zoom in and out on a croppie instance. Default = true                                                                                                     | bool                 |
| `showZoomer`          | Hide or show the zoom slider. Default = true                                                                                                                                                                      | bool                 |
| `presentStyle`        | Presentation style of cropper, either a dialog or a page (route). Default = dialog                                                                                                                                | CropperPresentStyle  |
| `context`             | Current BuildContext. The context is required to show cropper dialog or route                                                                                                                                     | BuildContext         |
| `customDialogBuilder` | Builder to customize the cropper Dialog                                                                                                                                                                           | CropperDialogBuilder |
| `customRouteBuilder`  | Builder to customize the cropper PageRoute                                                                                                                                                                        | CropperRouteBuilder  |

#### Note:

If using `CropperDialogBuilder` and `CropperRouteBuilder` to customize cropper dialog and route, the customization codes need to call `crop()` function to trigger crop feature and then returning the cropped result data to the plugin by using `Navigator.of(context).pop(result)`. 

````dart

 WebUiSettings(
   ...
   customDialogBuilder: (cropper, crop, rotate) {
      return Dialog(
       child: Builder(
         builder: (context) {
          return Column(
            children: [
              ...
              cropper,
              ...
              TextButton(
                onPressed: () async {
                  /// it is important to call crop() function and return
                  /// result data to plugin, for example:
                  final result = await crop();
                  Navigator.of(context).pop(result);
                },
                child: Text('Crop'),
              )
            ]
          );
        },
       ),
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
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    
````

## Credits

- Android: [uCrop](https://github.com/Yalantis/uCrop) created by [Yalantis](https://github.com/Yalantis)
- iOS: [TOCropViewController](https://github.com/TimOliver/TOCropViewController) created by [Tim Oliver](https://twitter.com/TimOliverAU)
- Web: [croppie](https://github.com/Foliotek/Croppie) created by [Foliotek](https://github.com/Foliotek) and [croppie-dart](https://gitlab.com/michel.werren/croppie-dart) created by [Michel Werren](https://gitlab.com/michel.werren)
