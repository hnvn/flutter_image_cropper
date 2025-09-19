## 7.2.0

* Android: `statusBarColor` is deprecated and no longer in use, introduce new properties `statusBarLight` and `navBarLight`

## 7.1.0

* fix bug on Flutter WASM [#567](https://github.com/hnvn/flutter_image_cropper/pull/567)

## 7.0.0

* relax flutter version constraints
* iOS: introduce `iOSUiSettings.embedInNavigationController` to support add2app environments

## 6.1.0

* replace deprecated API (`UnmodifiableUint8ListView` by `asUnmodifiableView`)
* increase Dart SDK constraints (`>=3.3.0`)

## 6.0.3

* Web: fix the issue of `WebDialogBuilder`, should return `Widget` instead of `Dialog`

## 6.0.2

* Web: fix bug cropper not get correct container's size

## 6.0.1

* add `backIcon` property in `WebThemeData` to support customization of `AppBar.leading` in `CropperPage`

## 6.0.0

* refactor `WebUiSettings` class to support new JS library
* move `cropStyle` and `aspectRatioPresets` into `AndroidUiSettings` and `IOSUiSettings` for sake of clean and clarity
* refactor `CropAspectRatioPreset` to support customized aspect ratio preset

## 5.0.0

* upgrade `http` to v1.0.0

## 4.0.0

* update SKD constraint
* refactor CHANGELOG

## 3.0.3

* support localization on Web

## 3.0.2

* correct `WebSettings` model

## 3.0.1

* correct default values of `WebUiSettings`

## 3.0.0

* **BREAKING CHANGE**: move all setting models to platform interface packages

## 2.0.0-beta.1

* **BREAKING CHANGE**: update result models to support web, replace `File` by `CroppedFile`

## 2.0.0-beta

* migrate to federated plugins
