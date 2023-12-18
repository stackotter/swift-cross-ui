// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "swift-cross-ui",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "SwiftCrossUI", targets: ["SwiftCrossUI"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "SwiftCrossUI",
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
    ]
)
