# WinUIBackend

SwiftCrossUI's native Windows backend built on WinUI 3.

## Overview

`WinUIBackend` supports both ARM64 and x64 Windows 10/11 computers. It is the recommended backend to use when compiling SwiftCrossUI apps for Windows, as it aims to provide the most native experience.

## System dependencies

Before you can use `WinUIBackend` there are two main dependencies that you must install; Windows SDK 10.0.17736 and WindowsAppSDK 1.5-preview1. The former is only required at compile time while the later is only required at runtime.

```sh
winget install --id Microsoft.WindowsSDK.10.0.17736
```
Figure 1: *Installing the required Windows SDK version using `winget`*

1. Install the required Windows SDK version using the command in Figure 1
2. Install the required WindowsAppSDK version using [this download link](https://aka.ms/windowsappsdk/1.5/1.5.240205001-preview1/windowsappruntimeinstall-x64.exe)

## Usage

```swift
...

let package = Package(
  ...
  targets: [
    ...
    .executableTarget(
      name: "YourApp",
      dependencies: [
        .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
        .product(name: "WinUIBackend", package: "swift-cross-ui"),
      ]
    )
    ...
  ]
  ...
)
```
Figure 2: *adding `WinUIBackend` to an executable target*

```swift
import SwiftCrossUI
import WinUIBackend

@main
struct YourApp: App {
  // You can explicitly initialize your app's chosen backend if you desire.
  // This happens automatically when you import any of the built-in backends.
  //
  // var backend = WinUIBackend()

  var body: some Scene {
    WindowGroup {
      Text("Hello, World!")
        .padding()
    }
  }
}
```
Figure 3: *using `WinUIBackend`*
