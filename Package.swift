// swift-tools-version:5.6

import Foundation
import PackageDescription

// Warn about a known SwiftPM issue on Windows
#if swift(<5.8) && os(Windows)
    if let pkgConfigPath = ProcessInfo.processInfo.environment["PKG_CONFIG_PATH"],
        pkgConfigPath.contains(":")
    {
        print("PKG_CONFIG_PATH might not be parsed correctly with your Swift tools version.")
        print("Upgrade to Swift 5.8+ instead.")
    }
#endif

// In Gtk 4.10 some breaking changes were made, so the GtkBackend code needs to know
// which version is in use.
var gtkSwiftSettings: [SwiftSetting] = []
if let version = getGtk4MinorVersion(), version >= 10 {
    gtkSwiftSettings.append(.define("GTK_4_10_PLUS"))
}

var swift510Dependencies: [Package.Dependency] = []
var swift510Targets: [Target] = []
var swift510Products: [Product] = []
#if swift(>=5.10)
    swift510Dependencies = [
        .package(
            url: "https://github.com/thebrowsercompany/swift-windowsappsdk",
            branch: "main"
        ),
        .package(
            url: "https://github.com/thebrowsercompany/swift-windowsfoundation",
            branch: "main"
        ),
        .package(
            url: "https://github.com/thebrowsercompany/swift-winui",
            branch: "main"
        ),
    ]

    swift510Products = [
        .library(name: "WinUIBackend", targets: ["WinUIBackend"])
    ]

    swift510Targets = [
        .target(
            name: "WinUIBackend",
            dependencies: [
                .product(name: "WinUI", package: "swift-winui"),
                .product(name: "WinAppSDK", package: "swift-windowsappsdk"),
                .product(name: "WindowsFoundation", package: "swift-windowsfoundation"),
            ]
        )
    ]
#endif

let defaultBackend: String
if let backend = ProcessInfo.processInfo.environment["SCUI_DEFAULT_BACKEND"] {
    defaultBackend = backend
} else {
    #if os(macOS)
        defaultBackend = "AppKitBackend"
    #elseif os(Windows)
        defaultBackend = "WinUIBackend"
    #else
        defaultBackend = "GtkBackend"
    #endif
}

let package = Package(
    name: "swift-cross-ui",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "SwiftCrossUI", targets: ["SwiftCrossUI"]),
        .library(name: "AppKitBackend", targets: ["AppKitBackend"]),
        .library(name: "CursesBackend", targets: ["CursesBackend"]),
        .library(name: "QtBackend", targets: ["QtBackend"]),
        .library(name: "LVGLBackend", targets: ["LVGLBackend"]),
        .library(name: "GtkBackend", targets: ["GtkBackend"]),
        .library(name: "Gtk", targets: ["Gtk"]),
        .executable(name: "GtkExample", targets: ["GtkExample"]),
    ] + swift510Products,
    dependencies: [
        .package(
            url: "https://github.com/CoreOffice/XMLCoder",
            from: "0.17.1"
        ),
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "508.0.0"
        ),
        // TODO: Switch to a different terminal library that doesn't have issues on non-Apple platforms
        .package(
            url: "https://github.com/stackotter/TermKit",
            revision: "163afa64f1257a0c026cc83ed8bc47a5f8fc9704"
        ),
        .package(
            url: "https://github.com/PADL/LVGLSwift",
            revision: "19c19a942153b50d61486faf1d0d45daf79e7be5"
        ),
        .package(
            url: "https://github.com/Longhanks/qlift",
            revision: "ddab1f1ecc113ad4f8e05d2999c2734cdf706210"
        ),
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.0.0"
        ),
    ] + swift510Dependencies,
    targets: [
        .target(
            name: "SwiftCrossUI",
            dependencies: [],
            exclude: [
                "Builders/ViewBuilder.swift.gyb",
                "ViewGraph/ViewGraphNodeChildren.swift.gyb",
                "Views/VariadicView.swift.gyb",
            ]
        ),
        .testTarget(
            name: "SwiftCrossUITests",
            dependencies: ["SwiftCrossUI"]
        ),
        .target(
            name: "DefaultBackend",
            dependencies: [
                .target(name: defaultBackend)
            ]
        ),
        .target(name: "AppKitBackend", dependencies: ["SwiftCrossUI"]),
        .target(
            name: "QtBackend",
            dependencies: ["SwiftCrossUI", .product(name: "Qlift", package: "qlift")]
        ),
        .target(
            name: "CursesBackend",
            dependencies: ["SwiftCrossUI", "TermKit"]
        ),
        .target(
            name: "LVGLBackend",
            dependencies: [
                "SwiftCrossUI",
                .product(name: "LVGL", package: "LVGLSwift"),
                .product(name: "CLVGL", package: "LVGLSwift"),
            ]
        ),
        .target(
            name: "GtkBackend",
            dependencies: ["SwiftCrossUI", "Gtk", "CGtk"]
        ),
        .systemLibrary(
            name: "CGtk",
            pkgConfig: "gtk4",
            providers: [
                .brew(["gtk4"]),
                .apt(["libgtk-4-dev clang"]),
            ]
        ),
        .target(name: "Gtk", dependencies: ["CGtk"], swiftSettings: gtkSwiftSettings),
        .executableTarget(
            name: "GtkExample",
            dependencies: ["Gtk"],
            resources: [.copy("GTK.png")]
        ),
        .executableTarget(
            name: "GtkCodeGen",
            dependencies: [
                "XMLCoder", .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
    ] + swift510Targets
)

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
