# Setting up a development environment

Detailed set up instructions for macOS, Linux, and Windows based development environments.

## Overview

Building a cross-platform app requires testing your app in a variety of environments. Setting up development environments can come with many platform-specific challenges. This article attempts to give an overview of the steps involved and touch on the most common pain-points for each platform.

In this article we'll focus on developing SwiftCrossUI apps with Swift Bundler, but much of the information should still apply if you choose to use a different build system.

> Note: This article covers setting up development environments on pre-existing machines. To develop in a virtual machine, first follow <doc:Setting-up-a-virtual-development-environment> then return to complete the set up process.

## Apple platforms

As you might expect, setting up a development environment for Apple platforms comes with the least challenges; as long as you have a Mac.

This article doesn't cover Apple development from Linux or Windows machines. However, Swift Bundler will likely support cross-compilation in the future. And in the mean time [xtool](https://xtool.sh) is a great option for targeting iOS from Linux and Windows; as long as you're ok with mixing and matching build systems to target various platforms.

We'll install the following tools:

- [Xcode](https://developer.apple.com/xcode/); even if you aren't using the editor, you'll still need the SDKs that come with it
- [Swift Bundler](https://swiftbundler.dev); this unifies your cross platform development experience with a consistent CLI interface and configuration format

### Installing Xcode

You have two main options:

- Install Xcode from the macOS App Store
- Install Xcode manually

Installing from the App Store is simple:

1. Just visit [Xcode's App Store page](https://apps.apple.com/us/app/xcode/id497799835?mt=12/)
2. Click GET

Installing manually gives you more flexibility. It also lets you install directly to an external storage device, which comes in handy if you're running low on storage. It goes like so:

1. Locate your desired Xcode release on [https://xcodereleases.com]
2. Click Download; this is take you to the requested Xcode release download in the Apple Developer portal, and requires an Apple Developer login
3. Unzip the `.xip` file. I recommend using [unxip](https://github.com/saagarjha/unxip); it's faster and it doesn't use temporary storage on your internal drive, which causes issue when low on storage and installing to an external drive.
4. Move `Xcode.app` to wherever you want it, whether that be `/Applications` or some external location.
5. Open Xcode and select the SDKs you need when it prompts you to install optional components.
6. Run `xcode-select --switch /path/to/Xcode.app` in terminal if installing Xcode at a non-standard location or alongside an existing version of Xcode.

### Installing Swift Bundler

Swift Bundler's [documentation](https://swiftbundler.dev/documentation/swift-bundler/installation) lists a wide variety of installation methods, but if you have Mint installed it's as easy as running `mint install stackotter/swift-bundler@main`.

Once installed, run `swift bundler` in terminal as a quick sanity check.

### Further steps

If you're only using <doc:AppKitBackend> and <doc:UIKitBackend> when targeting Apple platforms, then you're good to go.

If you'd like to test your app with <doc:GtkBackend> or <doc:Gtk3Backend> without leaving your Mac, visit the backends' respective documentation pages for detailed dependency installation instructions.

## Linux

We'll install the following:

- The latest stable [Swift toolchain](https://www.swift.org/install/linux/)
- [Swift Bundler](https://swiftbundler.dev)
- [Gtk](https://www.gtk.org/) (3 or 4 depending on which is available)

### Installing a Swift toolchain

With the release of [swiftly](https://github.com/swiftlang/swiftly), the official Swift toolchain manager, installing Swift toolchains on Linux has become much easier. That said, there are still a few things to watch out for when using less mainstream Linux distributions. If Swiftly doesn't work for you, feel free to use an alternative installation method as found on the [Swift installation instructions page](https://www.swift.org/install/linux).

1. Follow the [Swiftly-based installation instructions](https://www.swift.org/install/linux).
2. Make sure that `swift` is not only installed but also on your path by opening a new terminal window and running `swift --version`.

> Tip: If your Linux distribution isn't officially supported, check out [`xtremekforever`'s post on the Swift Forums](https://forums.swift.org/t/running-swift-on-unsupported-distributions/71741). It contains a table that tells you which distribution to select in Swiftly, or in the swfit.org downloads section, in order to maximise the chance of things working on your chosen distribution. The best distribution to download for isn't always the most intuitive.

### Installing Swift Bundler

Swift Bundler's [documentation](https://swiftbundler.dev/documentation/swift-bundler/installation) lists a wide variety of installation methods. If you have Mint installed, then installing Swift Bundler is as easy as running `mint install stackotter/swift-bundler@main`. A good alternative method is the manual installation method.

Once installed, run `swift-bundler` in terminal as a quick sanity check.

> Warning: If you're coming from macOS, you'll have to adjust your habits because `swift bundler` with a space instead of a hyphen doesn't work on Linux.

### Installing Gtk (3 or 4)

You're almost ready to go. The final step is to install the dependencies for the backend you'll be using. On Linux you're limited to <doc:GtkBackend> and <doc:Gtk3Backend>. We recommend using <doc:GtkBackend> unless you have a really good reason not to. <doc:Gtk3Backend> purely exists to support older Linux distributions, and doesn't support as many features.

> Tip: some distributions such as Ubuntu 22.04 allow you to install both Gtk 3 and Gtk 4. This can come in handy when you have to target both <doc:GtkBackend> and <doc:Gtk3Backend>.

Click through to your chosen backend for detailed dependency installation instructions:

- <doc:GtkBackend>
- <doc:Gtk3Backend>

## Windows

We'll install the following:

- The latest stable [Swift toolchain](https://www.swift.org/install/windows/)
- [Swift Bundler](https://swiftbundler.dev)
- <doc:WinUIBackend> related dependencies

### Installing a Swift toolchain

The [Swift installation instructions page](https://www.swift.org/install/windows/) lists various installation methods. The easiest is the WinGet-based method:

1. Visit the [Swift installation instructions page](https://www.swift.org/install/windows/).
2. Click the Instructions button in the WinGet installation method card.
3. Follow the installation instructions.
4. Run `swift --version` as a quick sanity check.

We don't include the instructions here because the Visual Studio version they depend on may change in the future.

### Installing Swift Bundler

Swift Bundler's [documentation](https://swiftbundler.dev/documentation/swift-bundler/installation) lists a wide variety of installation methods. The only one applicable to Windows at the moment is the manual installation method.

First we'll clone and build Swift Bundler locally. Make sure to do this in a location that you're ok with keeping around.

```sh
git clone https://github.com/stackotter/swift-bundler
cd swift-bundler
swift build -c release
```

Next we'll add Swift Bundler to the system Path so that you can run it from any directory. These instructions have been adapted from [a eukhost article](https://www.eukhost.com/kb/how-to-add-to-the-path-on-windows-10-and-windows-11/) which includes additional images that some may find useful.

1. Search for 'Edit the system environment variables' in the start menu. Select the matching option.
2. Click the `Environment Variables...` button.
3. Navigate to the `System Variables` tab.
4. Select the row corresponding to the `Path` variable and click `Edit...`.
5. Click `New`, and enter `absolute\path\to\swift-bundler\.build\release` (replacing with the appropriate path).
6. Save your changes by selecting `OK` a bunch of times.

Open a new command prompt window and run `swift bundler` as a quick sanity check.

### Installing WinUIBackend related dependencies

You're almost ready to start developing. That final step is to install the dependencies required by <doc:WinUIBackend>. Click through to <doc:WinUIBackend>'s documentation page for detailed installation instructions.

> Warning: You may run into strange Swift issues if you use Command Prompt for Swift development. We recommend always using the Native Tools Command Prompt for VS 2022, which you can find in the start menu.
