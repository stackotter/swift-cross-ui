// swift-tools-version:5.6

import Foundation
import PackageDescription

let backend = ProcessInfo.processInfo.environment["SCUI_BACKEND"] ?? "GtkBackend"

let exampleDependencies: [Target.Dependency] = [
    "SwiftCrossUI",
    "SelectedBackend",
]

let package = Package(
    name: "Examples",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(name: "SwiftCrossUI", path: "..")
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
        .target(
            name: "SelectedBackend",
            dependencies: [
                .product(name: backend, package: "SwiftCrossUI")
            ]
        ),
    ]
)
