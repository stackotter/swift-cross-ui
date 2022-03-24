// swift-tools-version:5.5

import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/stackotter/SwiftGtk",
        .branch("main"))
]

#if swift(>=5.6)
// Add the documentation compiler plugin if possible
dependencies.append(
    .package(
        url: "https://github.com/apple/swift-docc-plugin",
        from: "1.0.0")
)
#endif

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
        .executable(
            name: "WindowPropertiesExample",
            targets: ["WindowPropertiesExample"])
    ],
    dependencies: dependencies,
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
        .executableTarget(
            name: "WindowPropertiesExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/WindowProperties")
    ]
)
