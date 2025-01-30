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
        .package(url: "https://github.com/TimOliver/TOCropViewController.git", from: "2.7.4"),
    ],
    targets: [
        .target(
            name: "image_cropper",
            dependencies: [
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
