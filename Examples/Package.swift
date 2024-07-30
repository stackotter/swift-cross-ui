// swift-tools-version: 5.9

import Foundation
import PackageDescription

let backend = ProcessInfo.processInfo.environment["SCUI_BACKEND"] ?? "GtkBackend"

let exampleDependencies: [Target.Dependency] = [
    "SwiftCrossUI",
    // TODO: Switch to DefaultBackend once all examples work with all of the three major backends.
    "SelectedBackend",
    .product(
        name: "SwiftBundlerRuntime",
        package: "swift-bundler",
        condition: .when(platforms: [.macOS, .linux])
    ),
]

let package = Package(
    name: "Examples",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(name: "SwiftCrossUI", path: ".."),
        .package(
            url: "https://github.com/stackotter/swift-bundler",
            revision: "d5b56cf7cc967d262ad5330b83849069fcba7821"
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
        .target(
            name: "SelectedBackend",
            dependencies: [
                .product(name: backend, package: "SwiftCrossUI")
            ]
        ),
    ]
)
