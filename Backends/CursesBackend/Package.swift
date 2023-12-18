// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "CursesBackend",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "CursesBackend",
            targets: ["CursesBackend"]
        )
    ],
    dependencies: [
        .package(name: "SwiftCrossUI", path: "../../"),
        .package(
            url: "https://github.com/migueldeicaza/TermKit",
            revision: "3bce85d1bafbbb0336b3b7b7e905c35754cb9adf"
        ),
    ],
    targets: [
        .target(
            name: "CursesBackend",
            dependencies: ["SwiftCrossUI", "TermKit"]
        )
    ]
)
