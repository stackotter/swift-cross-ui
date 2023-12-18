// swift-tools-version:5.6

import PackageDescription

let backend = "GtkBackend"

let exampleDependencies: [Target.Dependency] = [
    "SwiftCrossUI", "SelectedBackend",
]

let package = Package(
    name: "Examples",
    platforms: [.macOS(.v10_15)],
    products: [],
    dependencies: [
        .package(name: "SwiftCrossUI", path: "../"),
        .package(path: "../Backends/\(backend)"),
    ],
    targets: [
        .executableTarget(
            name: "CounterExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "RandomNumberGeneratorExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "GreetingGeneratorExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "SplitExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "ControlsExample",
            dependencies: exampleDependencies
        ),
        .executableTarget(
            name: "WindowingExample",
            dependencies: exampleDependencies,
            resources: [.copy("Banner.png")]
        ),
        .executableTarget(
            name: "NavigationExample",
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
            dependencies: [.byName(name: backend)]
        ),
    ]
)
