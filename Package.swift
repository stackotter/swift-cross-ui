// swift-tools-version:5.5

import PackageDescription

var dependencies: [Package.Dependency] = []

#if swift(>=5.6)
// Add the documentation compiler plugin if possible
dependencies.append(
    .package(
        url: "https://github.com/apple/swift-docc-plugin",
        from: "1.0.0"
    )
)
#endif

#if os(macOS)
let cGtkSources = "Sources/CGtk/MacOS"
#elseif os(Linux) || os(Windows)
let cGtkSources = "Sources/CGtk/Linux+Windows"
#else
fatalError("Unsupported platform.")
#endif

let package = Package(
    name: "swift-cross-ui",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "SwiftCrossUI",
            targets: ["SwiftCrossUI"]
        ),
        .library(
            name: "Gtk",
            targets: ["Gtk"]
        ),
        .executable(
            name: "CounterExample",
            targets: ["CounterExample"]
        ),
        .executable(
            name: "RandomNumberGeneratorExample",
            targets: ["RandomNumberGeneratorExample"]
        ),
        .executable(
            name: "WindowPropertiesExample",
            targets: ["WindowPropertiesExample"]
        ),
        .executable(
            name: "GreetingGeneratorExample",
            targets: ["GreetingGeneratorExample"]
        ),
        .executable(
            name: "FileViewerExample",
            targets: ["FileViewerExample"]
        ),
        .executable(
            name: "NavigationExample",
            targets: ["NavigationExample"]
        ),
        .executable(
            name: "GtkExample",
            targets: ["GtkExample"]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "SwiftCrossUI",
            dependencies: [
                "Gtk",
                "CGtk"
            ],
            exclude: [
                "Builders/ViewContentBuilder.swift.gyb",
                "ViewGraph/ViewGraphNodeChildren.swift.gyb",
                "Views/ViewContent.swift.gyb"
            ]
        ),

        .systemLibrary(
            name: "CGtk",
            path: cGtkSources,
            pkgConfig: "gtk4",
            providers: [
                .brew(["gtk4"]),
                .apt(["libgtk-4-dev clang"])
            ]
        ),
        .target(
            name: "Gtk",
            dependencies: ["CGtk"]
        ),
        .executableTarget(
            name: "GtkExample",
            dependencies: ["Gtk"],
            resources: [.copy("GTK.png")]
        ),

        .executableTarget(
            name: "CounterExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/Counter"
        ),
        .executableTarget(
            name: "RandomNumberGeneratorExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/RandomNumberGenerator"
        ),
        .executableTarget(
            name: "WindowPropertiesExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/WindowProperties",
            resources: [.copy("Banner.png")]
        ),
        .executableTarget(
            name: "GreetingGeneratorExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/GreetingGenerator"
        ),
        .executableTarget(
            name: "FileViewerExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/FileViewer"
        ),
        .executableTarget(
            name: "NavigationExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/Navigation"
        )
    ]
)
