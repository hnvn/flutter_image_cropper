# Image Cropper

A Flutter plugin supports cropping images

<p>
	<img src="./screenshots/android.gif?raw=true" width="250" height="443"  />
	<img src="./screenshots/ios.gif?raw=true" width="250" height="443" />
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

## Credits
This plugin is based on two native libraries:

- Android: [uCrop](https://github.com/Yalantis/uCrop) created by [Yalantis](https://github.com/Yalantis)
- iOS: [TOCropViewController](https://github.com/TimOliver/TOCropViewController) created by [Tim Oliver](https://twitter.com/TimOliverAU)