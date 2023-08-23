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

## Community

Discussion about SwiftCrossUI now happens in the [SwiftCrossUI Discord server](https://discord.gg/fw2trT48ny) (it used to happen in a channel of the SwiftGtk Discord server). Feel free to [join](https://discord.gg/fw2trT48ny)
if you want to get involved, discuss the library, or just be kept up-to-date on progress!

## Supporting SwiftCrossUI

If you find SwiftCrossUI useful, please consider supporting me by [becoming a sponsor](https://github.com/sponsors/stackotter). I spend most of my spare time working on open-source projects, and each sponsorship helps me focus more time on making high quality libraries and tools for the community.

## Backends

Work has been started to support multiple different backends. Switching backends only requires changing a single
line of code! Currently there's the Gtk 4 backend, as well as an experimental AppKit backend (`AppKitBackend`, macOS-only). All
examples use `GtkBackend` for maximum compatibility, but you can update them manually to try out the various available backends.
Work is being done to allow the backend used by the examples to be changed from the command line.

- `GtkBackend`: Requires gtk 4 to be installed, has maximum compatibility, and supports all SwiftCrossUI features.
- `AppKitBackend`: ***Experimental***, only supports macOS, and currently supports a very limited subset of SwiftCrossUI features.
- `QtBackend`: ***Experimental***, requires `qt5` to be installed, and currently supports a very limited subset of SwiftCrossUI features.

## Example

Here's a simple example app demonstrate how easy it is to get started with SwiftCrossUI:

```swift
import SwiftCrossUI

class CounterState: Observable {
    @Observed var count = 0
}

@main
struct CounterApp: App {
    // An experimental AppKit backend is also available when on macOS (try AppKitBackend)
    // There's also a Qt5 backend (QtBackend) available when qt5 is installed
    typealias Backend = GtkBackend

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
2. Gtk 4 (only required for GtkBackend)
3. clang (only required on Linux for GtkBackend)
4. Qt5 (only required for QtBackend)

### Installing Qt5

```sh
# On macOS
brew install qt@5
brew link qt@5

# Linux with apt
sudo apt install qtcreator qtbase5-dev qt5-qmake cmake
```

### macOS: Installing Gtk 4

Install Gtk 4 using HomeBrew or the package manager of your choice.

```sh
brew install pkg-config gtk4
```

If you run into errors related to `libffi` or `FFI` when trying to build a swift-cross-ui project (likely caused by having Xcode CLTs installed), try running the following command to patch libffi:

```sh
sed -i '' 's/-I..includedir.//g' $(brew --prefix)/Library/Homebrew/os/mac/pkgconfig/*/libffi.pc
```

### Linux: Installing Gtk 4 and Clang

Install Gtk 4 and Clang using apt or the package manager of your choice. On most GNOME-based systems, Gtk should already be installed (although you should verify that it's Gtk 3).

```sh
sudo apt install libgtk-4-dev clang
```

If you run into errors related to not finding `gtk/gtk.h` when trying to build a swift-cross-ui project, try restarting your computer. This has worked in some cases (although there may be a more elegant solution).

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
