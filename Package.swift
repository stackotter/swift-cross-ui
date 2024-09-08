// swift-tools-version:5.10

import CompilerPluginSupport
import Foundation
import PackageDescription

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
                "SwiftCrossUI",
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

let hotReloadingEnabled: Bool
#if os(Windows)
    hotReloadingEnabled = false
#else
    hotReloadingEnabled =
        ProcessInfo.processInfo.environment["SWIFT_BUNDLER_HOT_RELOADING"] != nil
        || ProcessInfo.processInfo.environment["SCUI_HOT_RELOADING"] != nil
#endif

var swiftSettings: [SwiftSetting] = []
if hotReloadingEnabled {
    swiftSettings += [
        .define("HOT_RELOADING_ENABLED")
    ]
}

var libraryType: Product.Library.LibraryType?
switch ProcessInfo.processInfo.environment["SCUI_LIBRARY_TYPE"] {
    case "static":
        libraryType = .static
    case "dynamic":
        libraryType = .dynamic
    case "auto":
        libraryType = nil
    case .some:
        print("Invalid SCUI_LIBRARY_TYPE, expected static, dynamic, or auto")
        libraryType = nil
    case nil:
        if hotReloadingEnabled {
            libraryType = .dynamic
        } else {
            libraryType = nil
        }
}

let package = Package(
    name: "swift-cross-ui",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "SwiftCrossUI", type: libraryType, targets: ["SwiftCrossUI"]),
        .library(name: "AppKitBackend", type: libraryType, targets: ["AppKitBackend"]),
        .library(name: "CursesBackend", type: libraryType, targets: ["CursesBackend"]),
        .library(name: "QtBackend", type: libraryType, targets: ["QtBackend"]),
        .library(name: "GtkBackend", type: libraryType, targets: ["GtkBackend"]),
        .library(name: "DefaultBackend", type: libraryType, targets: ["DefaultBackend"]),
        .library(name: "Gtk", type: libraryType, targets: ["Gtk"]),
        .executable(name: "GtkExample", targets: ["GtkExample"]),
        // .library(name: "LVGLBackend", type: libraryType, targets: ["LVGLBackend"]),
    ] + swift510Products,
    dependencies: [
        .package(
            url: "https://github.com/CoreOffice/XMLCoder",
            from: "0.17.1"
        ),
        .package(
            url: "https://github.com/stackotter/TermKit",
            revision: "163afa64f1257a0c026cc83ed8bc47a5f8fc9704"
        ),
        // .package(
        //     url: "https://github.com/PADL/LVGLSwift",
        //     revision: "19c19a942153b50d61486faf1d0d45daf79e7be5"
        // ),
        .package(
            url: "https://github.com/Longhanks/qlift",
            revision: "ddab1f1ecc113ad4f8e05d2999c2734cdf706210"
        ),
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "510.0.0"
        ),
        .package(
            url: "https://github.com/stackotter/swift-macro-toolkit",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/stackotter/swift-image-formats",
            .upToNextMinor(from: "0.1.0")
        ),
    ] + swift510Dependencies,
    targets: [
        .target(
            name: "SwiftCrossUI",
            dependencies: [
                "HotReloadingMacrosPlugin",
                .product(name: "ImageFormats", package: "swift-image-formats"),
            ],
            exclude: [
                "Builders/ViewBuilder.swift.gyb",
                "Builders/TableRowBuilder.swift.gyb",
                "Views/TupleView.swift.gyb",
                "Views/TupleViewChildren.swift.gyb",
                "Views/TableRowContent.swift.gyb",
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
        // .target(
        //     name: "LVGLBackend",
        //     dependencies: [
        //         "SwiftCrossUI",
        //         .product(name: "LVGL", package: "LVGLSwift"),
        //         .product(name: "CLVGL", package: "LVGLSwift"),
        //     ]
        // ),
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
        .macro(
            name: "HotReloadingMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "MacroToolkit", package: "swift-macro-toolkit"),
            ],
            swiftSettings: swiftSettings
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

        guard (try? process.run()) != nil,
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
