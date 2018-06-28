# Image Cropper

A Flutter plugin for Android and iOS supports cropping images

[![pub package](https://img.shields.io/pub/v/image_cropper.svg)](https://pub.dartlang.org/packages/image_cropper)

<p>
	<img src="https://github.com/hnvn/flutter_image_cropper/blob/master/screenshots/android.gif?raw=true" width="250" height="443"  />
	<img src="https://github.com/hnvn/flutter_image_cropper/blob/master/screenshots/ios.gif?raw=true" width="250" height="443" />
</p>

## Installation

### Android

- Add UCropActivity into your AndroidManifest.xml

````xml
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
````

### iOS
- No configuration required

## Example

````dart
Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
}
````

## Credits
This plugin is based on two native libraries:

- Android: [uCrop](https://github.com/Yalantis/uCrop) created by [Yalantis](https://github.com/Yalantis)
- iOS: [TOCropViewController](https://github.com/TimOliver/TOCropViewController) created by [Tim Oliver](https://twitter.com/TimOliverAU)