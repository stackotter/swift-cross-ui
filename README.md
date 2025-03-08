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

> [!NOTE]
> SwiftCrossUI does not attempt to replicate SwiftUI's API perfectly since that would be a constantly-moving target and SwiftUI has many entrenched Apple-centric concepts. That said, SwiftCrossUI's built-in views and scenes share much of their API surface with their SwiftUI cousins, and over time SwiftCrossUI will likely adopt many of SwiftUI's commonly-used APIs.

## Overview

- [Community](#community)
- [Supporting SwiftCrossUI](#supporting-swiftcrossui)
- [Documentation](#documentation)
- [Basic example](#basic-example)
- [Backends](#backends)
- [More examples](#more-examples)
- [Quick start](#quick-start)

## Community

Discussion about SwiftCrossUI happens in the [SwiftCrossUI Discord server](https://discord.gg/fw2trT48ny). [Join](https://discord.gg/fw2trT48ny) to discuss the library, get involved, or just be kept up-to-date on progress!

## Supporting SwiftCrossUI

If you find SwiftCrossUI useful, please consider supporting me by [becoming a sponsor](https://github.com/sponsors/stackotter). I spend most of my spare time working on open-source projects, and each sponsorship helps me focus more time on making high quality libraries and tools for the community.

## Documentation

Here's the [documentation site](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui). SwiftCrossUI is still a work-in-progress; proper documentation and tutorials are on the horizon. Documentation contributions are very welcome!

## Basic example

Here's a simple example app demonstrating how easy it is to get started with SwiftCrossUI:

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

Clone the SwiftCrossUI repository to test out this example, and many more;

```sh
git clone https://github.com/stackotter/swift-cross-ui
cd swift-cross-ui/Examples
swift run CounterExample
```

The documentation contains [a detailed list of all examples]()

## Backends

SwiftCrossUI has a variety of backends tailored to different operating systems. The beauty of SwiftCrossUI is that you can write your app once and have it look native everywhere. For this reason I recommend using `DefaultBackend` unless you've got particular constraints.

> [!TIP]
> Click through each backend name for detailed system requirements and installation instructions.

- `DefaultBackend`: Adapts to your target operating system. On macOS it uses `AppKitBackend`, on Windows it uses `WinUIBackend`, on Linux it uses `GtkBackend`, and on iOS and tvOS it uses `UIKitBackend`.
- `AppKitBackend`: The native macOS backend. Supports all SwiftCrossUI features.
- `UIKitBackend`: The native iOS & tvOS backend. Supports most SwiftCrossUI features.
- `WinUIBackend`: The native Windows backend. Supports most SwiftCrossUI features.
- `GtkBackend`: Works on Linux, macOS, and Windows. Requires gtk 4 to be installed. Supports most SwiftCrossUI features.
- `Gtk3Backend`: Exists to target older Linux distributions. Requires gtk 3 to be installed. Supports most SwiftCrossUI features. Quite buggy on macOS due to underlying Gtk 3 bugs.

> [!TIP]
> If you're using `DefaultBackend`, you can override the underlying backend during compilation by setting the `SCUI_DEFAULT_BACKEND` environment variable to the name of the desired backend. This is useful when you e.g. want to test the Gtk version of your app while using a Mac. Note that this only works for built-in backends and still requires the chosen backend to be compatible with your machine.

## More examples

SwiftCrossUI includes many example apps, demonstrating most of its basic features.

- `CounterExample`: a simple app with buttons to increase and decrease a count.
- `RandomNumberGeneratorExample`, a simple app to generate random numbers between a minimum and maximum.
- `WindowingExample`: a simple app showcasing how ``WindowGroup`` is used to make multi-window apps and
  control the properties of each window.
- `GreetingGeneratorExample`: a simple app demonstrating dynamic state and the ``ForEach`` view.
- `FileViewerExample`: an app showcasing integration with the system's file chooser.
- `NavigationExample`: an app showcasing ``NavigationStack`` and related concepts.
- `SplitExample`: an app showcasing sidebar-based navigation with multiple levels.
- `StressTestExample`: an app used to test view update performance.
- `SpreadsheetExample`: an app showcasing tables.
- `ControlsExample`: an app showcasing the various types of controls available.

## Quick start

Although not strictly required, I recommend using [Swift Bundler](https://github.com/stackotter/swift-bundler) to build SwiftCrossUI apps; it simplifies many aspects of cross-platform distribution a great deal and provides a platform-agnostic configuration format for specifying things such as app icons and custom URL schemes. As such, this quick start guide will focus on Swift Bundler.

### Installing Swift Bundler

Follow [the installation instructions in Swift Bundler's readme](https://github.com/stackotter/swift-bundler?tab=readme-ov-file#installation-). `mint` is the preferred installation method as of the last update to this quick start guide.

### Installing system dependencies

Each backend has different requirements. In this guide we'll use `DefaultBackend` which uses `AppKitBackend` on macOS, `GtkBackend` on Linux, `WinUIBackend` on Windows, and `UIKitBackend` on iOS/tvOS. Click through the backend relevant to your machine for detailed installation requirements. `AppKitBackend` and `UIKitBackend` have no system dependencies; users of those two backends can skip this step.

### Using Swift Bundler's SwiftCrossUI template

Swift Bundler provides many built-in templates; we'll use the `SwiftCrossUI` template. The `SwiftCrossUI` template uses `DefaultBackend` to select the most appropriate backend at compile time.

```sh
swift bundler create HelloWorld --template SwiftCrossUI
cd HelloWorld
```

### Running your app

Running your new app with Swift Bundler is as simple as it gets!

```sh
swift bundler run
```

On macOS you can provide the `--device <device_name_or_id>` option to run the app on a connacted iOS or tvOS device, or the `--simulator <simulator_name_or_id>` option to run the app in a simulator.

```sh
# You can use any substring of the target device name. For example,
# "iPhone" matches any device connected with "iPhone" in its name.
swift bundler run --device "iPhone"
swift bundler run --simulator "iPhone 15"
```

### Making a change

Open `Sources/HelloWorld/HelloWorldApp.swift` in an editor of your choosing. Change `"Hello, World!"` to `"Hello, Earth!"`. Repeat the previous step to verify that your changes get reflected.

### All done

You're good to go! If you make something cool with SwiftCrossUI let us know so we can add your project to our showcase once the SwiftCrossUI website is up and running!
