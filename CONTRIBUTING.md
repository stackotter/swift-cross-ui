# Contributing

## Environment setup

1. Fork and clone SwiftGtkUI
2. Install the required dependencies as detailed in the [readme](README.md)
3. Open Package.swift to open the package in Xcode and you're ready to code, have fun

## Codestyle

To make working on SwiftGtk and SwiftGtkUI at the same time easier, SwiftGtkUI uses the same indentation as [SwiftGtk](https://github.com/stackotter/SwiftGtk).

- 4 space tabs
- Add comments to any code you think would need explaining to other contributors
- Document all methods, properties, classes, structs, protocols and enums with documentation comments (no matter how trivial, if it's trivial, you can just keep the documentation comment short). In Xcode you can press option+cmd+/ when your cursor is in a declaration to autogenerate a template documentation comment (it mostly works).

## Before opening a PR

- Make sure you have documented and new code and updated existing documentation as necessary
- Make sure that you haven't introduced any new warnings
- Make sure that the code builds, and the example works correctly
- If you are adding a new feature, consider adding an example usage of it to the example
