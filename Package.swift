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
            name: "CounterExample",
            dependencies: ["SwiftGtkUI"],
            path: "Examples/Counter"),
        .executableTarget(
            name: "RandomNumberGeneratorExample",
            dependencies: ["SwiftGtkUI"],
            path: "Examples/RandomNumberGenerator"),
    ]
)
