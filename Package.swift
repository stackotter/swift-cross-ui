// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "swift-cross-ui",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "SwiftCrossUI",
            targets: ["SwiftCrossUI"]),
        .executable(
            name: "CounterExample",
            targets: ["CounterExample"]),
        .executable(
            name: "RandomNumberGeneratorExample",
            targets: ["RandomNumberGeneratorExample"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/stackotter/SwiftGtk",
            .branch("main"))
    ],
    targets: [
        .target(
            name: "SwiftCrossUI",
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
            name: "CounterExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/Counter"),
        .executableTarget(
            name: "RandomNumberGeneratorExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/RandomNumberGenerator"),
    ]
)
