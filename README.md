<p align="center">
    <img width="100%" src="banner.png">
</p>

<p align="center">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20macOS/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Linux/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Windows/badge.svg?branch=main">
    <img alt="GitHub" src="https://img.shields.io/github/license/stackotter/swift-cross-ui">
</p>

A SwiftUI-like framework for creating cross-platform apps in Swift (using Gtk 4 as the backend).

This package is still quite a work-in-progress so don't expect it to be very useful or stable yet.

**NOTE**: SwiftCrossUI does not attempt to replicate SwiftUI's API because SwiftCrossUI is intended to be simpler than SwiftUI. However, many concepts from SwiftUI should still be transferrable.

## Example

Here's a simple example app demonstrate how easy it is to get started with SwiftCrossUI:

```swift
import SwiftCrossUI

class CounterState: Observable {
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
swift run GreetingGeneratorExample
swift run FileViewerExample
swift run NavigationExample
```

## Documentation

Here's the [documentation site](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui). Keep in mind that the project is still very much a work-in-progress, proper documentation and tutorials will be created once the project has matured a bit, because otherwise I have to spend too much time keeping the documentation up-to-date.

## Dependencies

1. Swift 5.5 or higher
2. Gtk 4
3. clang (only required on Linux)

### macOS: Installing Gtk 4

Install Gtk 4 using HomeBrew or the package manager of your choice.

```sh
brew install gtk4
```

### Linux: Installing Gtk 4 and Clang

Install Gtk 4 and Clang using apt or the package manager of your choice. On most GNOME-based systems, Gtk should already be installed (although you should verify that it's Gtk 3).

```sh
sudo apt install libgtk-4-dev clang
```

### Windows (experimental): Installing Gtk 4 through vcpkg

Installing Gtk 4 using vcpkg is the supported method for setting up SwiftCrossUI on Windows.

#### Install vcpkg

```cmd
git clone https://github.com/microsoft/vcpkg C:\vcpkg
C:\vcpkg\bootstrap-vcpkg.bat
```

> **NOTE**: It's important to install vcpkg to the root of `C:` or any other drive due to limitations of the Gtk build system.

#### Install Gtk 4 globally (recommended)

Run the following command to install Gtk 4 globally. This can take 45 minutes or longer depending on your machine. Running this command in the root of your drive will ensure that `vcpkg` doesn't run in manifest mode.

```cmd
C:\vcpkg\vcpkg.exe install gtk --triplet x64-windows
```

After installation, you must make the following changes to your environment variables:
1. Set the `PKG_CONFIG_PATH` environment variable to `C:\vcpkg\installed\x64-windows\lib\pkgconfig`. This is only required for building.
2. Add `C:\vcpkg\installed\x64-windows\bin` to your `Path` environment variable. This is only required for running.

If installing globally fails, try deleting `C:\vcpkg` and starting over, otherwise file an issue to the `vcpkg` repository and let me know at `stackotter@stackotter.dev`.

#### Install Gtk 4 with project manifest (more unreliable)

> **NOTE**: If the absolute path to your project contains spaces, it is possible that `vcpkg` will break, and installing globally will be a more reliable strategy.

You can install Gtk 4 inside your package workspace, to have a package-specific dependency store. First, create a `vcpkg.json` at your package root. You can download [the vcpkg.json file from this repo](vcpkg.json), or create it yourself;

```json
{
    "name": "swift-cross-ui",
    "version-string": "main",
    "dependencies": ["gtk"]
}
```

Change directory to your package root, then run the following command to build and install dependencies.

```cmd
C:\vcpkg\vcpkg.exe install --triplet x64-windows
```

After installation, you must make the following changes to your environment variables:
1. Set the `PKG_CONFIG_PATH` environment variable to `PACKAGE_ROOT\vcpkg_installed\x64-windows\lib\pkgconfig` to allow SwiftPM to consume the installed packages.
3. Add `C:\path\to\your\project\vcpkg_installed\x64-windows\bin` to your `PATH` environment variable.

If you run into issues (potentially related to `libsass`), try installing globally instead (see above).

#### Distribute SwiftCrossUI Apps

`vcpkg_installed\<triplet>\bin` contains all required DLLs for running a SwiftCrossUI application on Windows, but not all of them are necessary.

To identify which of them are required, you can use [the Dependencies tool](https://github.com/lucasg/Dependencies) to inspect the compiled executable, and copy all vcpkg-installed DLLs along with the executable for distribution.

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
