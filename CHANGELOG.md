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