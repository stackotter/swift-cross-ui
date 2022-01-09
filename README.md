# SwiftGtkUI

A SwiftUI-like framework for creating cross-platform apps in Swift. It uses [SwiftGtk](https://github.com/stackotter/SwiftGtk) as its backend.

**NOTE**: SwiftGtkUI does not attempt to replicate SwiftUI's API, it is merely inspired by SwiftUI. SwiftGtkUI is intended to be simpler than SwiftUI while also overcoming some of the limitations of SwiftUI. To achieve these goals, some fundamentally different design decisions were made which make exactly replicating the API impossible.

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

## Example

To run the example:

```sh
git clone https://github.com/stackotter/SwiftGtkUI
cd SwiftGtkUI
swift run Example
```

The buttons don't do anything yet because support for stateful UIs hasn't been implemented.
