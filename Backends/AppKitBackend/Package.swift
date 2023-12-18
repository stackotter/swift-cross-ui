// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "AppKitBackend",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "AppKitBackend",
            targets: ["AppKitBackend"]
        )
    ],
    dependencies: [
        .package(name: "SwiftCrossUI", path: "../../")
    ],
    targets: [
        .target(
            name: "AppKitBackend",
            dependencies: ["SwiftCrossUI"]
        )
    ]
)
