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

#if swift(<5.8) && os(Windows)
    if let pkgConfigPath = ProcessInfo.processInfo.environment["PKG_CONFIG_PATH"],
        pkgConfigPath.contains(":")
    {
        print("PKG_CONFIG_PATH might not be parsed correctly with your Swift tools version.")
        print("Upgrade to Swift 5.8+ instead.")
    }
#endif

#if !os(Linux) && !os(macOS) && !os(Windows)
    fatalError("Unsupported platform.")
#endif

var conditionalTargets: [Target] = []
var exampleDependencies: [Target.Dependency] = [
    "SwiftCrossUI", "GtkBackend",
]
var fileViewerExampleDependencies: [Target.Dependency] = ["SwiftCrossUI", "GtkBackend", "CGtk"]
var backendTargets: [String] = []

// If Gtk is detected, add Gtk-related products and targets
var gtkSwiftSettings: [SwiftSetting] = []
var gtkExampleDependencies: [Target.Dependency] = []
if let version = getGtk4MinorVersion() {
    gtkExampleDependencies.append("Gtk")
    backendTargets.append("GtkBackend")

    // Conditionally enable features that rely on Gtk 4.10
    if version >= 10 {
        gtkExampleDependencies.append("FileDialog")
        fileViewerExampleDependencies.append("FileDialog")
        gtkSwiftSettings.append(.define("GTK_4_10_PLUS"))
    }
}

#if canImport(AppKit)
    backendTargets.append("AppKitBackend")
#endif

if checkQtInstalled() {
    backendTargets.append("QtBackend")
    dependencies.append(
        .package(
            url: "https://github.com/Longhanks/qlift",
            revision: "ddab1f1ecc113ad4f8e05d2999c2734cdf706210"
        )
    )
}

if checkSDL2Installed() {
    backendTargets.append("LVGLBackend")
    dependencies.append(
        .package(
            url: "https://github.com/PADL/LVGLSwift",
            revision: "19c19a942153b50d61486faf1d0d45daf79e7be5"
        )
    )
}

#if os(macOS)
    // TODO: Switch to a different terminal library that doesn't have issues on non-Apple platforms
    backendTargets.append("CursesBackend")
    dependencies.append(
        .package(
            url: "https://github.com/migueldeicaza/TermKit",
            revision: "3bce85d1bafbbb0336b3b7b7e905c35754cb9adf"
        )
    )
    let withTermKit = true
#else /* !os(macOS) */
    let withTermKit = false
#endif /* os(macOS) */

let package = Package(
    name: "swift-cross-ui",
    platforms: [.macOS(.v10_15)],
    products: [
        // library products that are always applied.
        .library(name: "SwiftCrossUI", targets: ["SwiftCrossUI"]),

        // library products that are conditionally applied.
        .library(name: "GtkBackend", targets: ["GtkBackend"]),
        .library(name: "Gtk", targets: ["Gtk"]),
        .library(name: "AppKitBackend", targets: ["AppKitBackend"]),
        .library(name: "QtBackend", targets: ["QtBackend"]),
        .library(name: "LVGLBackend", targets: ["LVGLBackend"]),
        .library(name: "CursesBackend", targets: ["CursesBackend"]),

        // exectuable products that are always applied.
        .executable(name: "CounterExample", targets: ["CounterExample"]),
        .executable(
            name: "RandomNumberGeneratorExample",
            targets: ["RandomNumberGeneratorExample"]
        ),
        .executable(
            name: "WindowingExample",
            targets: ["WindowingExample"]
        ),
        .executable(
            name: "GreetingGeneratorExample",
            targets: ["GreetingGeneratorExample"]
        ),
        .executable(name: "FileViewerExample", targets: ["FileViewerExample"]),
        .executable(name: "NavigationExample", targets: ["NavigationExample"]),
        .executable(name: "SplitExample", targets: ["SplitExample"]),
        
        // exectuable products that are conditionally applied.
        .executable(name: "GtkExample", targets: ["GtkExample"]),
    ],
    dependencies: dependencies,
    targets: [
        // targets that are always applied.
        .target(
            name: "SwiftCrossUI",
            dependencies: [],
            exclude: [
                "Builders/ViewBuilder.swift.gyb",
                "ViewGraph/ViewGraphNodeChildren.swift.gyb",
                "Views/VariadicView.swift.gyb",
            ]
        ),

        // targets that are conditionally applied.
        .target(
            name: "FileDialog", 
            dependencies: (getGtk4MinorVersion() != nil ? [
                "CGtk", 
                "Gtk"
            ] : [])
        ),
        .target(
            name: "GtkBackend", 
            dependencies: [
                "SwiftCrossUI",
            ] + (getGtk4MinorVersion() != nil ? [
                "Gtk",
                "CGtk"
            ] : [])
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
            dependencies: (getGtk4MinorVersion() != nil ? [
                "CGtk",
            ] : []),
            swiftSettings: gtkSwiftSettings
        ),
    
        // backend targets that are conditionally applied.
        .target(name: "AppKitBackend", dependencies: ["SwiftCrossUI"]),
        .target(
            name: "QtBackend",
            dependencies: [
                "SwiftCrossUI",
            ] + (checkQtInstalled() ? [
                .product(name: "Qlift", package: "qlift")
            ] : [])
        ),
        .target(
            name: "LVGLBackend",
            dependencies: [
                "SwiftCrossUI",
            ] + (checkSDL2Installed() ? [
                .product(name: "LVGL", package: "LVGLSwift"),
                .product(name: "CLVGL", package: "LVGLSwift"),
            ] : [])
        ),
        .target(
            name: "CursesBackend",
            dependencies: [
                "SwiftCrossUI", 
            ] + (withTermKit ? [
                "TermKit",
            ] : [])
        ),

        // executables that are conditionally built.
        .executableTarget(
            name: "GtkExample",
            dependencies: gtkExampleDependencies,
            resources: [.copy("GTK.png")]
        ),
        .executableTarget(
            name: "GtkCodeGen",
            dependencies: [
                "XMLCoder", 
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),

        // executables that are always built.
        .executableTarget(
            name: "ControlsExample",
            dependencies: exampleDependencies,
            path: "Examples/Controls"
        ),
        .executableTarget(
            name: "CounterExample",
            dependencies: exampleDependencies,
            path: "Examples/Counter"
        ),
        .executableTarget(
            name: "RandomNumberGeneratorExample",
            dependencies: exampleDependencies,
            path: "Examples/RandomNumberGenerator"
        ),
        .executableTarget(
            name: "WindowingExample",
            dependencies: exampleDependencies,
            path: "Examples/Windowing",
            resources: [.copy("Banner.png")]
        ),
        .executableTarget(
            name: "GreetingGeneratorExample",
            dependencies: exampleDependencies,
            path: "Examples/GreetingGenerator"
        ),
        .executableTarget(
            name: "FileViewerExample",
            dependencies: fileViewerExampleDependencies,
            path: "Examples/FileViewer"
        ),
        .executableTarget(
            name: "NavigationExample",
            dependencies: exampleDependencies,
            path: "Examples/Navigation"
        ),
        .executableTarget(
            name: "SplitExample",
            dependencies: exampleDependencies,
            path: "Examples/Split"
        ),
        .executableTarget(
            name: "SpreadsheetExample",
            dependencies: exampleDependencies,
            path: "Examples/Spreadsheet"
        ),
        .executableTarget(
            name: "StressTestExample",
            dependencies: exampleDependencies,
            path: "Examples/StressTest"
        ),

        .testTarget(
            name: "SwiftCrossUITests",
            dependencies: ["SwiftCrossUI"]
        ),
    ]
)

func checkQtInstalled() -> Bool {
    #if os(Windows)
        // TODO: Test Qt backend on Windows
        return false
    #else
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", "qmake --version"]
        process.standardOutput = Pipe()
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    #endif
}

func checkSDL2Installed() -> Bool {
    #if os(Windows)
        // TODO: Test SDL backend on Windows
        return false
    #else
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", "sdl2-config --version"]
        process.standardOutput = Pipe()
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    #endif
}

func getGtk4MinorVersion() -> Int? {
    #if os(Windows)
        guard let pkgConfigPath = ProcessInfo.processInfo.environment["PKG_CONFIG_PATH"],
            case let tripletRoot = URL(fileURLWithPath: pkgConfigPath, isDirectory: true)
                .deletingLastPathComponent().deletingLastPathComponent(),
            case let vcpkgInfoDirectory = tripletRoot.deletingLastPathComponent()
                .appendingPathComponent("vcpkg").appendingPathComponent("info"),
            let installedList = try? FileManager.default.contentsOfDirectory(
                at: vcpkgInfoDirectory, includingPropertiesForKeys: nil
            )
            .map({ $0.deletingPathExtension().lastPathComponent }),
            let packageName = installedList.first(where: {
                $0.hasPrefix("gtk_") && $0.hasSuffix("_\(tripletRoot.lastPathComponent)")
            })
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
