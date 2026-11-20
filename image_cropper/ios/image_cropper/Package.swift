// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "image_cropper",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "image-cropper", targets: ["image_cropper"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/TimOliver/TOCropViewController.git", from: "3.2.0"),
    ],
    targets: [
        .target(
            name: "image_cropper",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "TOCropViewController", package: "TOCropViewController")
            ],
            resources: [],
            cSettings: [
                // TODO: Update your plugin name.
                .headerSearchPath("include/image_cropper")
            ]
        )
    ]
)
