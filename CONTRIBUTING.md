# Contributing

## Environment setup

1. Fork and clone SwiftGtkUI
2. Install the required dependencies as detailed in the [readme](README.md)
3. Open Package.swift to open the package in Xcode and you're ready to code, have fun

## How to do something useful

1. Look through the issues on GitHub and choose an issue to work on (or open one if you have an idea)
2. Leave a comment on the issue to let people know that you're working on it
3. Make necessary changes to the codebase
4. Open a PR, making sure to reference the issue that your changes address
5. If a maintainer requests changes, implement the changes
6. A maintainer will merge the changes and the issue can be closed
7. Thank you for improving SwiftGtkUI

## Before opening a PR

1. Make sure you have documented any new code and updated existing documentation as necessary
2. Make sure that you haven't introduced any new warnings
3. Make sure that the code builds, and the example works correctly
4. If you are adding a new feature, consider adding an example usage of it to the example

## While coding

Here are a few things to keep in mind while working on the code.

1. Do not directly modify a file that has a corresponding `.gyb` template file (which will be in the same directory). Instead, modify the template file and then run `./generate.sh` to build all of the templates. To learn more about gyb [read this post](https://nshipster.com/swift-gyb/)
3. Make sure to avoid massive monolithic commits where possible

## Codestyle

To make working on SwiftGtk and SwiftGtkUI at the same time easier, SwiftGtkUI uses the same indentation as [SwiftGtk](https://github.com/stackotter/SwiftGtk).

- 4 space tabs
- Add comments to any code you think would need explaining to other contributors
- Document all methods, properties, classes, structs, protocols and enums with documentation comments (no matter how trivial, if it's trivial, you can just keep the documentation comment short). In Xcode you can press option+cmd+/ when your cursor is on a declaration to autogenerate a template documentation comment (it mostly works)
- Avoid using shorthand when the alternative is more readable at a glance
