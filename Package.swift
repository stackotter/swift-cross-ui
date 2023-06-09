// swift-tools-version:5.5

import Foundation
import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/CoreOffice/XMLCoder",
        from: "0.17.1"
    ),
    .package(
        url: "https://github.com/apple/swift-syntax.git",
        from: "508.0.0"
    ),
]

#if swift(>=5.6) && !os(Windows)
    // Add the documentation compiler plugin if possible
    dependencies.append(
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.0.0"
        )
    )
#endif

#if !os(Linux) && !os(macOS) && !os(Windows)
fatalError("Unsupported platform.")
#endif

// Conditionally enable features that rely on Gtk 4.10
var conditionalTargets: [Target] = []
var swiftCrossUIDependencies: [Target.Dependency] = ["Gtk"]
var gtkExampleDependencies: [Target.Dependency] = ["Gtk"]
var gtkSwiftSettings: [SwiftSetting] = []
if let version = getGtk4MinorVersion(), version >= 10 {
    conditionalTargets.append(
        .target(
            name: "FileDialog",
            dependencies: ["CGtk", "Gtk"]
        )
    )

    swiftCrossUIDependencies.append("FileDialog")
    gtkExampleDependencies.append("FileDialog")
    gtkSwiftSettings.append(.define("GTK_4_10_PLUS"))
}

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
            name: "SplitExample",
            targets: ["SplitExample"]
        ),
        .executable(
            name: "GtkExample",
            targets: ["GtkExample"]
        ),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "SwiftCrossUI",
            dependencies: swiftCrossUIDependencies,
            exclude: [
                "Builders/ViewContentBuilder.swift.gyb",
                "ViewGraph/ViewGraphNodeChildren.swift.gyb",
                "Views/ViewContent.swift.gyb",
            ]
        ),
        .systemLibrary(
            name: "CGtk",
            pkgConfig: "gtk4",
            providers: [
                .brew(["gtk4"]),
                .apt(["libgtk-4-dev clang"]),
            ]
        ),
        .target(
            name: "Gtk",
            dependencies: ["CGtk"],
            swiftSettings: gtkSwiftSettings
        ),
        .executableTarget(
            name: "GtkExample",
            dependencies: gtkExampleDependencies,
            resources: [.copy("GTK.png")]
        ),

        .executableTarget(
            name: "GtkCodeGen",
            dependencies: [
                "XMLCoder", .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
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
        ),
        .executableTarget(
            name: "SplitExample",
            dependencies: ["SwiftCrossUI"],
            path: "Examples/Split"
        ),
    ] + conditionalTargets
)

func getGtk4MinorVersion() -> Int? {
#if os(Windows)
    guard let pkgConfigPath = ProcessInfo.processInfo.environment["PKG_CONFIG_PATH"],
          case let tripletRoot = URL(fileURLWithPath: pkgConfigPath, isDirectory: true)
              .deletingLastPathComponent().deletingLastPathComponent(),
          case let vcpkgInfoDirectory = tripletRoot.deletingLastPathComponent()
              .appendingPathComponent("vcpkg").appendingPathComponent("info"),
          let installedList = try? FileManager.default.contentsOfDirectory(at: vcpkgInfoDirectory, includingPropertiesForKeys: nil)
            .map({ $0.deletingPathExtension().lastPathComponent }),
          let packageName = installedList.first(where: { $0.hasPrefix("gtk_") && $0.hasSuffix("_\(tripletRoot.lastPathComponent)") })
    else {
        print("We only support installing gtk through vcpkg on Windows.")
        return nil
    }

    let version = packageName.split(separator: "_")[1].split(separator: ".")
#else
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/bash")
    process.arguments = ["-c", "gtk4-launch --version"]
    let pipe = Pipe()
    process.standardOutput = pipe

    guard let _ = try? process.run(),
          let data = try? pipe.fileHandleForReading.readToEnd(),
          case _ = process.waitUntilExit(),
          let version = String(data: data, encoding: .utf8)?.split(separator: ".")
    else {
        print("Failed to get gtk version")
        return nil
    }
#endif
    guard version.count >= 2, let minor = Int(version[1]) else {
        print("Failed to get gtk version")
        return nil
    }
    return minor
}
