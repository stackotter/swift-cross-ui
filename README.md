# SwiftGtkUI

A SwiftUI-like framework for creating cross-platform apps in Swift. It uses [SwiftGtk](https://github.com/stackotter/SwiftGtk) as its backend.

This project is still very much a work-in-progress, proper documentation and tutorials will be created once the project has matured a bit, because otherwise I have to spend too much time keeping the documentation up-to-date.

**NOTE**: SwiftGtkUI does not attempt to replicate SwiftUI's API because SwiftGtkUI is intended to be simpler than SwiftUI. However, many concepts from SwiftUI should still be transferrable.

## Example

Here's a simple example app demonstrate how easy it is to get started with SwiftGtkUI:

```swift
import SwiftGtkUI

class CounterState: AppState {
    @Observed var count = 0
}

@main
struct CounterApp: App {
    let identifier = "dev.stackotter.CounterApp"
    
    let state = CounterState()
    
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
git clone https://github.com/stackotter/SwiftGtkUI
cd SwiftGtkUI
swift run CounterExample
```

To see all of the examples, run these commands:

```sh
swift run CounterExample
swift run RandomNumberGeneratorExample
```

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

Just add SwiftGtkUI as a dependency in your `Package.swift`. See below for an example package manifest:

```swift
import PackageDescription

let package = Package(
  name: "Example",
  dependencies: [
    .package(url: "https://github.com/stackotter/SwiftGtkUI", .branch("main"))
  ],
  targets: [
    .executableTarget(name: "Example", dependencies: ["SwiftGtkUI"])
  ]
)
```
