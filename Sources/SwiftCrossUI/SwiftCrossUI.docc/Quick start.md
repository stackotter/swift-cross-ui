# Quick start

Creating a cross-platform SwiftCrossUI app with Swift Bundler.

## Overview

This quick start guide uses [Swift Bundler](https://github.com/stackotter/swift-bundler). Although not strictly required, it simplifies many aspects of cross-platform distribution and provides a platform-agnostic configuration format for specifying things such as app icons and custom URL schemes.

> Note: If you're new to Swift, we recommend starting with <doc:Setting-up-a-development-environment>.

## Installing Swift Bundler

Follow [the installation instructions in Swift Bundler's readme](https://github.com/stackotter/swift-bundler?tab=readme-ov-file#installation-). `mint` is the preferred installation method on macOS and Linux as of the last update to this quick start guide.

## Installing system dependencies

Each backend has different requirements. In this guide we'll use <doc:DefaultBackend> which uses <doc:AppKitBackend> on macOS, <doc:GtkBackend> on Linux, <doc:WinUIBackend> on Windows, and <doc:UIKitBackend> on iOS/tvOS. Click through the backend relevant to your machine for detailed installation requirements. <doc:AppKitBackend> and <doc:UIKitBackend> have no system dependencies.

## Using Swift Bundler's SwiftCrossUI template

Swift Bundler provides many built-in templates; we'll use the `SwiftCrossUI` template. The `SwiftCrossUI` template uses `DefaultBackend` to select the most appropriate backend at compile time.

```sh
swift bundler create HelloWorld --template SwiftCrossUI
cd HelloWorld
```

## Running your app

Running your new app with Swift Bundler is as simple as it gets!

```sh
swift bundler run
```

On macOS you can provide the `--device <device_name_or_id>` option to run the app on a connected iOS or tvOS device, or the `--simulator <simulator_name_or_id>` option to run the app in a simulator.

```sh
# You can use any substring of the target device name. For example,
# "iPhone" matches any device connected with "iPhone" in its name.
swift bundler run --device "iPhone"
swift bundler run --simulator "iPhone 15"
```

## Making a change

Open `Sources/HelloWorld/HelloWorldApp.swift` in an editor of your choosing. Change `"Hello, World!"` to `"Hello, Earth!"`. Repeat the previous step to verify that your changes get reflected.

## All done

You're good to go! If you make something cool with SwiftCrossUI let us know so we can add your project to our showcase once the SwiftCrossUI website is up and running!
