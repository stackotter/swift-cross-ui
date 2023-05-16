# Basic Usage

The basics of setting up and using SwiftCrossUI.

## Installing Dependencies

Before you can add SwiftCrossUI to your project and start working, you'll need to setup some dependencies.

### macOS

First, install `brew` if it isn't already installed. Instructions on how to do that can be found at [brew.sh](https://brew.sh).

Next, run the following command to install GTK 4.10+:
```
brew install gtk4
```

And you're done!

__Xcode users:__ If Xcode has trouble finding GTK 4 after you've installed it, try restarting your computer.

__Note:__ Package managers other than `brew` should also work, as long as they provide a `gtk4` package.

### Linux

If you're on a Debian or Ubuntu-based Linux distro, you can use the following command to install GTK 4.10+ and Clang:
```
sudo apt install libgtk-4-dev clang
```

If your distro uses a different package manager, the package names will likely be similar.

## Adding SwiftCrossUI to Your Project

To add SwiftCrossUI to your project, add the following dependency to your `Package.swift` file.
```swift
.package(url: "https://github.com/stackotter/swift-cross-ui", .branch("main"))
```

Here's an example package file that uses SwiftCrossUI.
```swift
import PackageDescription

let package = Package(
  name: "Example",
  dependencies: [
    .package(url: "https://github.com/stackotter/swift-cross-ui", .branch("main"))
  ],
  targets: [
    .executableTarget(
      name: "Example",
      dependencies: [
        .product(name: "SwiftCrossUI", package: "swift-cross-ui")
      ]
    )
  ]
)
```
