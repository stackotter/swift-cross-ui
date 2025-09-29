// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "swift-cross-ui",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        .library(name: "SwiftCrossUI", targets: ["SwiftCrossUI"]),
        .library(name: "AppKitBackend", targets: ["AppKitBackend"]),
        .library(name: "GtkBackend", targets: ["GtkBackend"]),
        .library(name: "Gtk3Backend", targets: ["Gtk3Backend"]),
        .library(name: "DefaultBackend", targets: ["DefaultBackend"]),
        .library(name: "UIKitBackend", targets: ["UIKitBackend"]),
        .library(name: "Gtk", targets: ["Gtk"]),
        .library(name: "Gtk3", targets: ["Gtk3"]),
        .executable(name: "GtkExample", targets: ["GtkExample"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/XMLCoder", from: "0.17.1"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "500.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftCrossUI",
            dependencies: [
                .product(name: "ImageFormats", package: "swift-image-formats"),
            ]
        ),
        .testTarget(
            name: "SwiftCrossUITests",
            dependencies: ["SwiftCrossUI"]
        ),
        .target(
            name: "DefaultBackend",
            dependencies: [
                .target(name: "AppKitBackend", condition: .when(platforms: [.macOS])),
                .target(name: "UIKitBackend", condition: .when(platforms: [.iOS, .tvOS, .macCatalyst])),
            ]
        ),
        .target(name: "AppKitBackend", dependencies: ["SwiftCrossUI"]),
        .target(name: "GtkBackend", dependencies: ["SwiftCrossUI", "Gtk", "CGtk"]),
        .systemLibrary(
            name: "CGtk",
            pkgConfig: "gtk4",
            providers: [
                .brew(["gtk4"]),
                .apt(["libgtk-4-dev clang"]),
            ]
        ),
    ]
)
