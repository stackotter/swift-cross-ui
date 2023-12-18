// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "LVGLBackend",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "LVGLBackend",
            targets: ["LVGLBackend"]
        )
    ],
    dependencies: [
        .package(name: "SwiftCrossUI", path: "../../"),
        .package(
            url: "https://github.com/PADL/LVGLSwift",
            revision: "19c19a942153b50d61486faf1d0d45daf79e7be5"
        ),
    ],
    targets: [
        .target(
            name: "LVGLBackend",
            dependencies: [
                "SwiftCrossUI",
                .product(name: "LVGL", package: "LVGLSwift"),
                .product(name: "CLVGL", package: "LVGLSwift"),
            ]
        )
    ]
)
