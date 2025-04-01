// swift-tools-version: 5.9

import Foundation
import PackageDescription

let exampleDependencies: [Target.Dependency] = [
    .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
    .product(name: "DefaultBackend", package: "swift-cross-ui"),
    .product(
        name: "SwiftBundlerRuntime",
        package: "swift-bundler",
        condition: .when(platforms: [.macOS, .linux])
    ),
]

let package = Package(
    name: "Examples",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .macCatalyst(.v13)],
    dependencies: [
        .package(name: "swift-cross-ui", path: ".."),
        .package(
            url: "https://github.com/stackotter/swift-bundler",
            revision: "7a3ee20eaeb3cf1aa1f0a9a056c01c9c4ccb6e2a"
        ),
    ],
    targets: [
        .executableTarget(
            name: "ControlsExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "CounterExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "RandomNumberGeneratorExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "WindowingExample",
            dependencies: exampleDependencies,
            resources: [.copy("Banner.png")]
        ),
        .executableTarget(
            name: "GreetingGeneratorExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "NavigationExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "SplitExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "SpreadsheetExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "StressTestExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "NotesExample",
            dependencies: exampleDependencies
        ),
    ]
)
