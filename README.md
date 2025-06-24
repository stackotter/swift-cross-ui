<p align="center">
    <img width="100%" src="banner.png">
</p>

<p align="center">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20macOS/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Linux/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Windows/badge.svg?branch=main">
    <img alt="GitHub" src="https://img.shields.io/github/license/stackotter/swift-cross-ui">
</p>

A SwiftUI-like framework for creating cross-platform apps in Swift (5.10+).

To dive right in with SwiftCrossUI, check out [the SwiftCrossUI quick start guide](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/quick-start).

> [!NOTE]
> SwiftCrossUI does not attempt to replicate SwiftUI's API perfectly since that would be a constantly-moving target and SwiftUI has many entrenched Apple-centric concepts. That said, SwiftCrossUI's built-in views and scenes share much of their API surface with their SwiftUI cousins, and over time SwiftCrossUI will likely adopt many of SwiftUI's commonly-used APIs.

## Overview

- [Community](#community)
- [Supporting SwiftCrossUI](#supporting-swiftcrossui)
- [Documentation](#documentation)
- [Basic example](#basic-example)
- [Backends](#backends)

## Community

Discussion about SwiftCrossUI happens in the [SwiftCrossUI Discord server](https://discord.gg/fw2trT48ny). [Join](https://discord.gg/fw2trT48ny) to discuss the library, get involved, or just be kept up-to-date on progress!

## Supporting SwiftCrossUI

If you find SwiftCrossUI useful, please consider supporting me by [becoming a sponsor](https://github.com/sponsors/stackotter). I spend most of my spare time working on open-source projects, and each sponsorship helps me focus more time on making high quality libraries and tools for the community.

## Documentation

Here's the [documentation site](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui). SwiftCrossUI is still a work-in-progress; proper documentation and tutorials are on the horizon. Documentation contributions are very welcome!

## Basic example

Here's a simple example app demonstrating how easy it is to get started with SwiftCrossUI. For a more detailed walkthrough, check out our [quick start guide](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/quick-start)

```swift
import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/stackotter/swift-cross-ui", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "YourApp",
            dependencies: [
                .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
                .product(name: "DefaultBackend", package: "swift-cross-ui"),
            ]
        )
    ]
)
```
Figure 1: *Package.swift*

```swift
import SwiftCrossUI
import DefaultBackend

@main
struct CounterApp: App {
    @State var count = 0

    var body: some Scene {
        WindowGroup("CounterApp") {
            HStack {
                Button("-") { count -= 1 }
                Text("Count: \(count)")
                Button("+") { count += 1 }
            }.padding()
        }
    }
}
```

Clone the SwiftCrossUI repository to test out this example and others. Running the examples requires an installation of [Swift Bundler](https://github.com/stackotter/swift-bundler), which provides consistent behavior across platforms and enables running on iOS and tvOS simulators and devices.

To install Swift Bundler, you can follow [its official installation instructions](https://github.com/stackotter/swift-bundler?tab=readme-ov-file#installation-). Swift Bundler is typically installed using [Mint](https://github.com/yonaskolb/Mint?tab=readme-ov-file#installing), a Swift package manager that lets you easily install and run CLI tools distributed as Swift packages.

If you don't have Mint installed, you can install it with [Homebrew](https://brew.sh/):

```sh
brew install mint
```

Then use Mint to install Swift Bundler:

```sh
mint install stackotter/swift-bundler@main
```

Once installed, clone the project and run the example:

```sh
git clone https://github.com/stackotter/swift-cross-ui
cd swift-cross-ui/Examples
swift bundler run CounterExample
```

You can also run on iOS and tvOS:

```sh
# On a connected device with "iPhone" in its name (macOS only)
swift bundler run CounterExample device iPhone

# On a simulator with "iPhone 16" in its name (macOS only)
swift bundler run CounterExample simulator "iPhone 16"
```

These examples may also be run on your host machine without Swift Bundler by using SwiftPM:

```sh
swift run CounterExample
```

However, resources may not be loaded as expected, and features like deep linking may not work. This method also does not support running on iOS or tvOS.

The documentation contains [a detailed list of all examples](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/examples)

## Backends

SwiftCrossUI has a variety of backends tailored to different operating systems. The beauty of SwiftCrossUI is that you can write your app once and have it look native everywhere. For this reason I recommend using [DefaultBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/defaultbackend) unless you've got particular constraints.

> [!TIP]
> Click through each backend name for detailed system requirements and installation instructions.

- [DefaultBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/defaultbackend): Adapts to your target operating system. On macOS it uses [AppKitBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/appkitbackend), on Windows it uses [WinUIBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/winuibackend), on Linux it uses [GtkBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/gtkbackend), and on iOS and tvOS it uses [UIKitBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/uikitbackend).
- [AppKitBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/appkitbackend): The native macOS backend. Supports all SwiftCrossUI features.
- [UIKitBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/uikitbackend): The native iOS & tvOS backend. Supports most SwiftCrossUI features.
- [WinUIBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/winuibackend): The native Windows backend. Supports most SwiftCrossUI features.
- [GtkBackend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/gtkbackend): Works on Linux, macOS, and Windows. Requires gtk 4 to be installed. Supports most SwiftCrossUI features.
- [Gtk3Backend](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui/gtk3backend): Exists to target older Linux distributions. Requires gtk 3 to be installed. Supports most SwiftCrossUI features. Quite buggy on macOS due to underlying Gtk 3 bugs.

> [!TIP]
> If you're using DefaultBackend, you can override the underlying backend during compilation by setting the `SCUI_DEFAULT_BACKEND` environment variable to the name of the desired backend. This is useful when you e.g. want to test the Gtk version of your app while using a Mac. Note that this only works for built-in backends and still requires the chosen backend to be compatible with your machine.
