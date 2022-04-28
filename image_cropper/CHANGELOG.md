
## [2.0.0] - 2022-04-28

* Support Web
* **BREAKING CHANGE**:
  - change result data type from `File` to `CroppedFile`.
  - remove `androidUiSettings` and `iosUiSettings`, they are replaced by `uiSettings`

### ***MIGRATION GUIDE***

#### **BEFORE**
```dart
File croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
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
```

#### **AFTER**
```dart
File croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );
```

## [2.0.0-beta.3] - 2022-04-01

* support rotate image on Web

## [2.0.0-beta.2] - 2022-03-27

* correct missing README document about Web support.

## [2.0.0-beta.1] - 2022-03-27

* **BREAKING CHANGE**: update result models to support web, replace `File` by `CroppedFile`

## [2.0.0-beta] - 2022-02-19

* migrate to federated plugins
* **BREAKING CHANGE**: remove `androidUiSettings` and `iosUiSettings`, they are replaced by `uiSettings` for sake of supporting multiple platforms in future.

### ***MIGRATION GUIDE***

#### **BEFORE**
```dart
File croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
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
```

#### **AFTER**
```dart
File croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );
```

## [1.5.1] - 2022-04-01

* update README to introduce Web support experiment

## [1.5.0] - 2022-02-19

* Upgrade `uCrop` to v2.2.8
* Upgrade `TOCropViewController` to v2.6.1
* PR: [#309](https://github.com/hnvn/flutter_image_cropper/pull/309), #[229](https://github.com/hnvn/flutter_image_cropper/pull/299), #[294](https://github.com/hnvn/flutter_image_cropper/pull/294), [#258](https://github.com/hnvn/flutter_image_cropper/pull/258), [#251](https://github.com/hnvn/flutter_image_cropper/pull/258)
* **BREAKING CHANGE**: change `cropImage()` to instance method

## [1.4.1] - 2021-06-20

* Upgrade `uCrop` to v2.2.7

## [1.4.0] - 2021-03-07

* Upgrade `TOCropViewController` to v2.6.0
* Migrate to nullsafety

## [1.3.1] - 2020-08-31

* Upgrade `uCrop` to v2.2.6
* Fix bug: image compress file format (png)

## [1.3.0] - 2020-08-09

* Update `pubspec` to new format
* Upgrade `TOCropViewController` to v2.5.4

## [1.2.3] - 2020-06-08

* Android: fix bug

## [1.2.2] - 2020-05-12

* Android: upgrade uCrop to v2.2.5
* **BREAKING CHANGE**: remove `activeWidgetColor` from `AndroidUiSettings`

## [1.2.1] - 2020-02-01

* iOS: add more UI customization properties (title, initRect)
* update Flutter version constraint (>= v1.12.13)

## [1.2.0] - 2020-01-19

* Android: migrate to embedding v2

## [1.1.2] - 2019-12-18

* Android: fix bug crashing on Flutter v1.12.13

## [1.1.1] - 2019-11-30

* Android: upgrade gradle version
* iOS: remove `static_framework` Pod configuration, upgrade `TOCropViewController` to 2.5.2

## [1.1.0] - 2019-09-29

* **BIG UPDATES**: supports UI customization on both of Android and iOS, supports more image compress format and quality.
* **BREAKING CHANGE**: `ratioX` and `ratioY` are replaced by `aspectRatio`, `circleShape` is replaced by `cropStyle`, removed `toolbarTitle` and `toolbarColor` (these properties are moved into `AndroidUiSettings`)
* iOS: upgrade native library (TOCropViewController v2.5.1)
* Android: upgrade native library (uCrop v2.2.4)

## [1.0.2] - 2019-05-25

* iOS: upgrade native library
* Android: fix bug #40

## [1.0.1] - 2019-04-15

* Android: migrate to AndroidX
* upgrade native libraries

## [1.0.0] - 2019-02-09

* Android: remove deprecated support libraries
* Android: target version to 28

## [0.0.9] - 2018-11-14

* clarify code document

## [0.0.8] - 2018-10-12

* set default value for `circleShape`

## [0.0.7] - 2018-10-10

* support circular cropping

## [0.0.6] - 2018-08-29

* upgrade `TOCropViewController` dependency to v2.3.8

## [0.0.5] - 2018-08-10

* re-config to support Dart2
* fix bug: lock aspect ratio

## [0.0.4] - 2018-07-06

* refactor: change `toolbarColor` type of `int` to `Color`

## [0.0.3] - 2018-07-05

* fix bug: increasing image size after cropping
* add new feature: `toolbarTitle` and `toolbarColor` to customize title and color of copper `Activity`

## [0.0.2] - 2018-06-28

* clarify document

## [0.0.1] - 2018-06-27

* initial release.