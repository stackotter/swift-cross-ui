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
            url: "https://github.com/stackotter/SwiftGtk",
            .branch("main")),
        .package(
            url: "https://github.com/OpenCombine/OpenCombine",
            from: "0.13.0")
    ],
    targets: [
        .target(
            name: "SwiftGtkUI",
            dependencies: ["SwiftGtk", "OpenCombine"]),
        .executableTarget(
            name: "Example",
            dependencies: ["SwiftGtkUI", "OpenCombine"]),
    ]
)
