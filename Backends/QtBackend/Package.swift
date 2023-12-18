// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "QtBackend",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "QtBackend",
            targets: ["QtBackend"]
        )
    ],
    dependencies: [
        .package(name: "SwiftCrossUI", path: "../../"),
        .package(
            url: "https://github.com/Longhanks/qlift",
            revision: "ddab1f1ecc113ad4f8e05d2999c2734cdf706210"
        ),
    ],
    targets: [
        .target(
            name: "QtBackend",
            dependencies: ["SwiftCrossUI", .product(name: "Qlift", package: "qlift")]
        )
    ]
)
