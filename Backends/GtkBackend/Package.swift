// swift-tools-version:5.6

import Foundation
import PackageDescription

#if swift(<5.8) && os(Windows)
    if let pkgConfigPath = ProcessInfo.processInfo.environment["PKG_CONFIG_PATH"],
        pkgConfigPath.contains(":")
    {
        print("PKG_CONFIG_PATH might not be parsed correctly with your Swift tools version.")
        print("Upgrade to Swift 5.8+ instead.")
    }
#endif

// Certain changes made in Gtk 4.10 weren't backwards compatible so we need to
// be able to check the Gtk version at compile time.
var gtkSwiftSettings: [SwiftSetting] = []
if let version = getGtk4MinorVersion(), version >= 10 {
    gtkSwiftSettings.append(.define("GTK_4_10_PLUS"))
}

let package = Package(
    name: "GtkBackend",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "GtkBackend",
            targets: ["GtkBackend"]
        ),
        .library(
            name: "Gtk",
            targets: ["Gtk"]
        ),
        .executable(
            name: "GtkExample",
            targets: ["GtkExample"]
        ),
    ],
    dependencies: [
        .package(name: "SwiftCrossUI", path: "../../"),
        .package(
            url: "https://github.com/CoreOffice/XMLCoder",
            from: "0.17.1"
        ),
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "508.0.0"
        ),
    ],
    targets: [
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

        .target(
            name: "Gtk",
            dependencies: ["CGtk"],
            swiftSettings: gtkSwiftSettings
        ),

        .executableTarget(
            name: "GtkExample",
            dependencies: ["Gtk"],
            resources: [.copy("GTK.png")]
        ),

        .executableTarget(
            name: "GtkCodeGen",
            dependencies: [
                "XMLCoder",
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
    ]
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
