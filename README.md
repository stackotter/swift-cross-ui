<p align="center">
    <img width="100%" src="banner.png">
</p>

<p align="center">
    <img src="https://img.shields.io/github/workflow/status/stackotter/swift-cross-ui/Swift/main">
    <img alt="GitHub" src="https://img.shields.io/github/license/stackotter/swift-cross-ui">
</p>

A SwiftUI-like framework for creating cross-platform apps in Swift. It uses [SwiftGtk](https://github.com/stackotter/SwiftGtk) as its backend.

This package is still quite a work-in-progress so don't expect it to be very useful or stable yet.

**NOTE**: SwiftCrossUI does not attempt to replicate SwiftUI's API because SwiftCrossUI is intended to be simpler than SwiftUI. However, many concepts from SwiftUI should still be transferrable.

## Example

Here's a simple example app demonstrate how easy it is to get started with SwiftCrossUI:

```swift
import SwiftCrossUI

class CounterState: AppState {
    @Observed var count = 0
}

@main
struct CounterApp: App {
    let identifier = "dev.stackotter.CounterApp"
    
    let state = CounterState()
    
    let windowProperties = WindowProperties(title: "CounterApp")
    
    var body: some ViewContent {
        HStack {
            Button("-") { state.count -= 1 }
            Text("Count: \(state.count)")
            Button("+") { state.count += 1 }
        }
    }
}
```

To run this example, run these commands:

```sh
git clone https://github.com/stackotter/swift-cross-ui
cd swift-cross-ui
swift run CounterExample
```

To see all of the examples, run these commands:

```sh
swift run CounterExample
swift run RandomNumberGeneratorExample
swift run WindowPropertiesExample
```

## Documentation

Here's the [documentation site](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui). Keep in mind that the project is still very much a work-in-progress, proper documentation and tutorials will be created once the project has matured a bit, because otherwise I have to spend too much time keeping the documentation up-to-date.

## Dependencies

1. Swift 5.5 or higher
2. Gtk+ 3
3. clang (only required on Linux)

### macOS: Installing Gtk+ 3

Install Gtk+ 3 using homebrew or the package manager of your choice.

```sh
brew install gtk+3
```

### Linux: Installing Gtk+ 3 and clang

Install Gtk+3 and Clang using apt or the package manager of your choice.

```sh
sudo apt install libgtk-3-dev clang
```

## Usage

Just add SwiftCrossUI as a dependency in your `Package.swift`. See below for an example package manifest:

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
