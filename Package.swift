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
            .branch("main"))
    ],
    targets: [
        .target(
            name: "SwiftGtkUI",
            dependencies: [
                "SwiftGtk",
                .product(name: "CGtk", package: "SwiftGtk")
            ],
            exclude: [
                "Builders/ViewContentBuilder.swift.gyb",
                "ViewGraph/ViewGraphNodeChildren.swift.gyb",
                "Views/ViewContent.swift.gyb"
            ]),
        .executableTarget(
            name: "Example",
            dependencies: ["SwiftGtkUI"]),
    ]
)
