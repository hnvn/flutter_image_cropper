## 8.0.2

* Android: fix deprecated API
* web: correct constraints of flutter version (>=3.22.0)

## 8.0.1

* use `>=0.5.0 < 2.0.0` version range for package:web

## 8.0.0

* upgrade `web` dependency  
* relax flutter version constraints
* iOS: Prefer presented view controller if preset to Root view controller
* iOS: introduce `iOSUiSettings.embedInNavigationController` to support add2app environments

## 7.1.0

* upgrade `platform_interface` dependency
* increase Dart SDK constraints (`>=3.3.0`)
* Android: Removes references to Flutter v1 android embedding classes.

## 7.0.5

* Web: support config type of output image (jpg or png)

## 7.0.4

* Web: update dependencies

## 7.0.3

* Web: improve cropper UI

## 7.0.2

* Web:
  - fix bug cropper not get correct container's size
  - improve cropper UI
* correct document


## 7.0.1

* correct document

## 7.0.0

* refactor plugin to use new JS library, `cropperjs` instead of `croppie`
* support Wasm
* support customize `CropAspectRatioPreset`
* **BREAKING CHANGES**:

    - **WebUiSettings**: is totally re-implemented, please see plugin document for more details
    - **cropImage()**: move `cropStyle` and `aspectRatioPresets` into `AndroidUiSettings` and `IOUiSettings` for sake of clean and clarity.

    **Migration guides**:

    ***Before***:
    ```
    File croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    ```

    ***After***:
    ```
    File croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
          ],
        ),
      ],
    );
    ```

    **Web integration**:

    ***Before***:
    ```
    <head>
        ....

        <!-- Croppie -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.css" />
        <script defer src="https://cdnjs.cloudflare.com/ajax/libs/exif-js/2.3.0/exif.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.js"></script>

        ....
    </head>
    ```

    ***After***:
    ```
    <head>
        ....

        <!-- cropperjs -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.2/cropper.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.2/cropper.min.js"></script>

        ....
    </head>
    ```

## 6.0.0

* Android: upgrade `uCrop` to v2.2.9
* iOS: upgrade `TOCropViewController` to v2.7.3
* web: upgrade `js` to v0.7.1

## 5.0.1

* Android: improve compression quality

## 5.0.0

* upgrade `http` to v1.0.0

## 4.0.1

* refactor CHANGELOG

## 4.0.0

* Android: support namespace, Gradle 8

## 3.0.3

* iOS: bump ios minimum version to 11

## 3.0.2

* Web: fix web translation issue

## 3.0.1

* Android: replace `jcenter` by `mavenCentral`
* Web: support localization

## 3.0.0

* **BREAKING CHANGE**: move all setting models to platform interface packages.
* Separate Javascript codes from `WebSettings` model (so there's no need to use conditional import to config Web UI now)

### ***MIGRATION GUIDE***

#### **BEFORE**

```dart
WebUiSettings(
  boundary: Boundary(
    width: 520,
    height: 520,
  ),
  viewPort: ViewPort(width: 480, height: 480, type: 'circle'),
)
```

#### **AFTER**
```dart
WebUiSettings(
  boundary: const CroppieBoundary(
    width: 520,
    height: 520,
  ),
  viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
)
```

## 2.0.3

* correct importing JS library

## 2.0.2

* update document

## 2.0.1

* fix missing pubspec config on web

## 2.0.0

* Support Web
* **BREAKING CHANGE**:
  - change result data type from `File` to `CroppedFile`.
  - remove `androidUiSettings` and `iosUiSettings` parameter in `cropImage` method, they are replaced by `uiSettings`

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
CroppedFile croppedFile = await ImageCropper().cropImage(
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

## 2.0.0-beta.3

* support rotate image on Web

## 2.0.0-beta.2

* correct missing README document about Web support.

## 2.0.0-beta.1

* **BREAKING CHANGE**: update result models to support web, replace `File` by `CroppedFile`

## 2.0.0-beta

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

## 1.5.1

* update README to introduce Web support experiment

## 1.5.0

* Upgrade `uCrop` to v2.2.8
* Upgrade `TOCropViewController` to v2.6.1
* PR: [#309](https://github.com/hnvn/flutter_image_cropper/pull/309), #[229](https://github.com/hnvn/flutter_image_cropper/pull/299), #[294](https://github.com/hnvn/flutter_image_cropper/pull/294), [#258](https://github.com/hnvn/flutter_image_cropper/pull/258), [#251](https://github.com/hnvn/flutter_image_cropper/pull/258)
* **BREAKING CHANGE**: change `cropImage()` to instance method

## 1.4.1

* Upgrade `uCrop` to v2.2.7

## 1.4.0

* Upgrade `TOCropViewController` to v2.6.0
* Migrate to nullsafety

## 1.3.1

* Upgrade `uCrop` to v2.2.6
* Fix bug: image compress file format (png)

## 1.3.0

* Update `pubspec` to new format
* Upgrade `TOCropViewController` to v2.5.4

## 1.2.3

* Android: fix bug

## 1.2.2

* Android: upgrade uCrop to v2.2.5
* **BREAKING CHANGE**: remove `activeWidgetColor` from `AndroidUiSettings`

## 1.2.1

* iOS: add more UI customization properties (title, initRect)
* update Flutter version constraint (>= v1.12.13)

## 1.2.0

* Android: migrate to embedding v2

## 1.1.2

* Android: fix bug crashing on Flutter v1.12.13

## 1.1.1

* Android: upgrade gradle version
* iOS: remove `static_framework` Pod configuration, upgrade `TOCropViewController` to 2.5.2

## 1.1.0

* **BIG UPDATES**: supports UI customization on both of Android and iOS, supports more image compress format and quality.
* **BREAKING CHANGE**: `ratioX` and `ratioY` are replaced by `aspectRatio`, `circleShape` is replaced by `cropStyle`, removed `toolbarTitle` and `toolbarColor` (these properties are moved into `AndroidUiSettings`)
* iOS: upgrade native library (TOCropViewController v2.5.1)
* Android: upgrade native library (uCrop v2.2.4)

## 1.0.2

* iOS: upgrade native library
* Android: fix bug #40

## 1.0.1

* Android: migrate to AndroidX
* upgrade native libraries

## 1.0.0

* Android: remove deprecated support libraries
* Android: target version to 28

## 0.0.9

* clarify code document

## 0.0.8

* set default value for `circleShape`

## 0.0.7

* support circular cropping

## 0.0.6

* upgrade `TOCropViewController` dependency to v2.3.8

## 0.0.5

* re-config to support Dart2
* fix bug: lock aspect ratio

## 0.0.4

* refactor: change `toolbarColor` type of `int` to `Color`

## 0.0.3

* fix bug: increasing image size after cropping
* add new feature: `toolbarTitle` and `toolbarColor` to customize title and color of copper `Activity`

## 0.0.2

* clarify document

## 0.0.1

* initial release.
