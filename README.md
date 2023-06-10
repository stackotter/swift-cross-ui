<p align="center">
    <img width="100%" src="banner.png">
</p>

<p align="center">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20macOS/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Linux/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Windows/badge.svg?branch=main">
    <img alt="GitHub" src="https://img.shields.io/github/license/stackotter/swift-cross-ui">
</p>

A SwiftUI-like framework for creating cross-platform apps in Swift. It uses Gtk 4.10+ as its backend.

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
2. Gtk 4.10+
3. clang (only required on Linux)

### macOS: Installing Gtk 4.10+

Install Gtk 4.10+ using HomeBrew or the package manager of your choice.

```sh
brew install gtk4
```

### Linux: Installing Gtk 4.10+ and Clang

Install Gtk+ and Clang using apt or the package manager of your choice. Ensure that the installed
version of Gtk is Gtk 4.10+

```sh
sudo apt install libgtk-4-dev clang
```

### Windows (experimental): Installing Gtk 4.10+ through vcpkg

Install Gtk+ using vcpkg is strongly suggested on Windows.

#### Install vcpkg

```cmd
git clone https://github.com/microsoft/vcpkg C:\vcpkg
C:\vcpkg\bootstrap-vcpkg.bat
```

> **NOTE**: It's important to install vcpkg to the root of `C:` or any other drive due to limitations of Gtk build system.

You should set default triplet with environment variable. For more context, see [microsoft/vcpkg-tool#881](https://github.com/microsoft/vcpkg-tool/pull/881).

```cmd
set VCPKG_DEFAULT_TRIPLET=x64-windows
```

```powershell
$env:VCPKG_DEFAULT_TRIPLET = "x64-windows"
```

#### Install Gtk 4.10+ package-wide (recommended)

You can install Gtk+ inside your package workspace, to have a package-specific dependency store. First, create a `vcpkg.json` at your package root, e.g.

```json
{
    "name": "swift-cross-ui",
    "version-string": "main",
    "dependencies": ["gtk"]
}
```

You can also copy the file from [here](vcpkg.json).

Change directory to your package root, then build and install dependencies with:

```cmd
C:\vcpkg\vcpkg.exe install
```

Set `PKG_CONFIG_PATH` environment variable to `PACKAGE_ROOT\vcpkg_installed\x64-windows\lib\pkgconfig` to allow SwiftPM to consume the installed packages.

Add `PACKAGE_ROOT\vcpkg_installed\x64-windows\bin` to `Path` for running targets using SwiftCrossUI, either independently or through `swift run`.

#### Install Gtk 4.10+ globally

Alternatively, you can install Gtk+ in global installation path, alongside with other globally installed packages:

```cmd
C:\vcpkg\vcpkg.exe install gtk
```

Set `PKG_CONFIG_PATH` environment variable to `C:\vcpkg\installed\x64-windows\lib\pkgconfig` to allow SwiftPM to consume the installed packages.

Add `C:\vcpkg\installed\x64-windows\bin` to `Path` for running targets using SwiftCrossUI, either independently or through `swift run`.

#### Distribute SwiftCrossUI Apps

`vcpkg_installed\<triplet>\bin` contains all required DLLs for running a SwiftCrossUI application on Windows, but not all of them are necessary.

To identify which of them are required, you can use tools like [Dependencies](https://github.com/lucasg/Dependencies) to inspect the application executable, and copy all vcpkg-installed DLLs along with the executable for distribution.

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
