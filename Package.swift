// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftGtkUI",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "SwiftGtkUI",
            targets: ["SwiftGtkUI"]),
        .executable(
            name: "Example",
            targets: ["Example"]),
    ],
    dependencies: [
        .package(
            name: "SwiftGtk",
            url: "https://github.com/stackotter/SwiftGtk",
            .branch("main"))
    ],
    targets: [
        .target(
            name: "SwiftGtkUI",
            dependencies: ["SwiftGtk"]),
        .executableTarget(
            name: "Example",
            dependencies: ["SwiftGtkUI"]),
    ]
)
