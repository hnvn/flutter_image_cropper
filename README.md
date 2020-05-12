# Image Cropper

[![pub package](https://img.shields.io/pub/v/image_cropper.svg)](https://pub.dartlang.org/packages/image_cropper)


A Flutter plugin for Android and iOS supports cropping images. This plugin is based on two different native libraries so it comes with different UI between these platforms.

## Introduction

**Image Cropper** doesn't manipulate images in Dart codes directly, instead, the plugin uses [Platform Channel](https://flutter.dev/docs/development/platform-integration/platform-channels) to expose Dart APIs that Flutter application can use to communicate with two very powerful native libraries ([uCrop](https://github.com/Yalantis/uCrop) and [TOCropViewController](https://github.com/TimOliver/TOCropViewController)) to crop and rotate images. Because of that, all credits belong to these libraries.

### uCrop - Yalantis 
[![GitHub watchers](https://img.shields.io/github/watchers/Yalantis/uCrop.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/watchers/)  [![GitHub stars](https://img.shields.io/github/stars/Yalantis/uCrop.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/stargazers/)  [![GitHub forks](https://img.shields.io/github/forks/Yalantis/uCrop.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/Yalantis/uCrop/network/) [![](https://jitpack.io/v/Yalantis/uCrop.svg)](https://jitpack.io/#Yalantis/uCrop) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This project aims to provide an ultimate and flexible image cropping experience. Made in Made in [Yalantis](https://yalantis.com/?utm_source=github)

<p align="center">
	<img src="https://github.com/hnvn/flutter_image_cropper/blob/master/screenshots/android_demo.gif?raw=true" width="200"  />
</p>

### TOCropViewController - TimOliver
[![GitHub watchers](https://img.shields.io/github/watchers/TimOliver/TOCropViewController.svg?style=social&label=Watch&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/watchers/)  [![GitHub stars](https://img.shields.io/github/stars/TimOliver/TOCropViewController.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/stargazers/)  [![GitHub forks](https://img.shields.io/github/forks/TimOliver/TOCropViewController.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/TimOliver/TOCropViewController/network/) [![Version](https://img.shields.io/cocoapods/v/TOCropViewController.svg?style=flat)](http://cocoadocs.org/docsets/TOCropViewController) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/TimOliver/TOCropViewController/master/LICENSE)

`TOCropViewController` is an open-source `UIViewController` subclass to crop out sections of `UIImage` objects, as well as perform basic rotations. It is excellent for things like editing profile pictures, or sharing parts of a photo online. It has been designed with the iOS Photos app editor in mind, and as such, behaves in a way that should already feel familiar to users of iOS.

<p align="center">
  <img src="https://github.com/hnvn/flutter_image_cropper/blob/master/screenshots/ios_demo.gif?raw=true" width="200" />
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

## Usage

### Required paramsters

* **sourcePath**: the absolute path of an image file.

### Optional parameters

* **maxWidth**: maximum cropped image width.

* **maxHeight**: maximum cropped image height.

* **aspectRatio**: controls the aspect ratio of crop bounds. If this values is set, the cropper is locked and user can't change the aspect ratio of crop bounds.

* **aspectRatioPresets**: controls the list of aspect ratios in the crop menu view. In Android, you can set the initialized aspect ratio when starting the cropper by setting the value of `AndroidUiSettings.initAspectRatio`.

* **cropStyle**: controls the style of crop bounds, it can be rectangle or circle style (default is `CropStyle.rectangle`).

* **compressFormat**: the format of result image, png or jpg (default is ImageCompressFormat.jpg).

* **compressQuality**: the value [0 - 100] to control the quality of image compression.

* **androidUiSettings**: controls UI customization on Android. See [Android customization](#android-1).

* **iosUiSettings**: controls UI customization on iOS. See [iOS customization](#ios-1).

### Note

The result file is saved in `NSTemporaryDirectory` on iOS and application Cache directory on Android, so it can be lost later, you are responsible for storing it somewhere permanent (if needed).

## Customization

### Android

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


### iOS

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

## Example

````dart

import 'package:image_cropper/image_cropper.dart';

File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );
    
````


## Credits

- Android: [uCrop](https://github.com/Yalantis/uCrop) created by [Yalantis](https://github.com/Yalantis)
- iOS: [TOCropViewController](https://github.com/TimOliver/TOCropViewController) created by [Tim Oliver](https://twitter.com/TimOliverAU)
