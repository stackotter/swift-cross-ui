<p align="center">
    <img width="100%" src="banner.png">
</p>

<p align="center">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20macOS/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Linux/badge.svg?branch=main">
    <img src="https://github.com/stackotter/swift-cross-ui/workflows/Build%20Windows/badge.svg?branch=main">
    <img alt="GitHub" src="https://img.shields.io/github/license/stackotter/swift-cross-ui">
</p>

A SwiftUI-like framework for creating cross-platform apps in Swift.

This package is still quite a work-in-progress so don't expect it to be very useful or stable yet.

**NOTE**: SwiftCrossUI does not attempt to replicate SwiftUI's API perfectly because SwiftCrossUI is intended to be simpler than SwiftUI. However, many concepts from SwiftUI should still be transferrable.

## Community

Discussion about SwiftCrossUI now happens in the [SwiftCrossUI Discord server](https://discord.gg/fw2trT48ny) (it used to happen in a channel of the SwiftGtk Discord server). Feel free to [join](https://discord.gg/fw2trT48ny)
if you want to get involved, discuss the library, or just be kept up-to-date on progress!

## Supporting SwiftCrossUI

If you find SwiftCrossUI useful, please consider supporting me by [becoming a sponsor](https://github.com/sponsors/stackotter). I spend most of my spare time working on open-source projects, and each sponsorship helps me focus more time on making high quality libraries and tools for the community.

## Backends

SwiftCrossUI has a variety of backends tailored to different operating systems. The beauty of SwiftCrossUI is that you can write your app once and have it look native everywhere. For this reason I recommend using `DefaultBackend` unless you've got particular constraints.

If you use `DefaultBackend`, like the examples do, you can override the default when compiling your app by setting the `SCUI_DEFAULT_BACKEND` environment variable to the name of your desired backend. This can be quite useful when you e.g. want to test the Gtk version of your app while using a Mac.

- `DefaultBackend`: Adapts to your target operating system. On macOS it uses `AppKitBackend`, on Windows it uses `WinUIBackend`, on Linux it uses `GtkBackend`, and on iOS and tvOS it uses `UIKitBackend`.
- `AppKitBackend`: The native macOS backend. Supports all SwiftCrossUI features.
- `UIKitBackend`: The native iOS & tvOS backend. Supports most SwiftCrossUI features.
- `WinUIBackend`: The native Windows backend. Supports most SwiftCrossUI features.
- `GtkBackend`: Works on Linux, macOS, and Windows. Requires gtk 4 to be installed. Supports most SwiftCrossUI features.
- `Gtk3Backend`: Exists to target older Linux distributions. Requires gtk 3 to be installed. Supports most SwiftCrossUI features. Quite buggy on macOS because Gtk 3 itself doesn't support macOS very well.

## Example

Here's a simple example app demonstrate how easy it is to get started with SwiftCrossUI:

```swift
import SwiftCrossUI
// Import whichever backend you need
import DefaultBackend

@main
struct CounterApp: App {
    // You can explicitly provide your selected backend to SwiftCrossUI if you
    // want extra control. This allows you to configure the backend if the
    // backend has alternative initializers.
    //
    //  var backend = DefaultBackend()

    @State var count = 0

    var body: some Scene {
        WindowGroup("CounterApp") {
            HStack {
                Button("-") {
                    count -= 1
                }
                Text("Count: \(count)")
                Button("+") {
                  count += 1
                }
            }
            .padding(10)
        }
    }
}
```

To run this example, run these commands:

```sh
git clone https://github.com/stackotter/swift-cross-ui
cd swift-cross-ui/Examples
swift run CounterExample
```

### Other examples

A few examples are included with SwiftCrossUI to demonstrate some of its basic features.

- `CounterExample`, a simple app with buttons to increase and decrease a count.
- `RandomNumberGeneratorExample`, a simple app to generate random numbers between a minimum and maximum.
- `WindowingExample`, a simple app showcasing how ``WindowGroup`` is used to make multi-window apps and
  control the properties of each window.
- `GreetingGeneratorExample`, a simple app demonstrating dynamic state and the ``ForEach`` view.
- `FileViewerExample`, an app showcasing integration with the system's file chooser.
- `NavigationExample`, an app showcasing ``NavigationStack`` and related concepts.
- `SplitExample`, an app showcasing sidebar-based navigation with multiple levels.
- `StressTestExample`, an app used to test view update performance.
- `SpreadsheetExample`, an app showcasing tables.
- `ControlsExample`, an app showcasing the various types of controls available.

### Running examples on other backends

All of the examples use `DefaultBackend`, so when building the examples you can simply set the `SCUI_DEFAULT_BACKEND` environment variable to try out the various backends (limited of course by the compatibility of the various backends with your operating system).

```
SCUI_DEFAULT_BACKEND=QtBackend swift run CounterExample
```

## Documentation

Here's the [documentation site](https://stackotter.github.io/swift-cross-ui/documentation/swiftcrossui). Keep in mind that the project is still very much a work-in-progress, proper documentation and tutorials will be created once the project has matured a bit, because otherwise I have to spend too much time keeping the documentation up-to-date.

## Dependencies

1. Swift 5.5 or higher
2. Gtk 4 (only required for GtkBackend)
3. clang (only required on Linux for GtkBackend)
4. Qt5 (only required for QtBackend)

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

Install Gtk 4 and Clang using apt or the package manager of your choice. On most GNOME-based systems, Gtk should already be installed (although you should verify that it's Gtk 4).

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

### Installing Qt5

```sh
# On macOS
brew install qt@5
brew link qt@5

# Linux with apt
sudo apt install qtcreator qtbase5-dev qt5-qmake cmake
```

## Usage

Just add SwiftCrossUI as a dependency in your `Package.swift`. See below for an example package manifest:

```swift
import PackageDescription

let package = Package(
  name: "Example",
  dependencies: [
    .package(url: "https://github.com/stackotter/swift-cross-ui", branch: "main")
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
