# Contributing

## Environment setup

1. Fork and clone SwiftCrossUI
2. Install the required dependencies as detailed in the [readme](README.md)
3. Open Package.swift to open the package in Xcode and you're ready to code, have fun

## Running tests

Due to limitations of Swift Package Manager and the way this project is structured, running tests is a little more annoying than just running `swift test`. Luckily, there's a handy [test.sh](Scripts/test.sh) script which performs the required workaround. To run the tests, just run `./Scripts/test.sh` in the root of the repository.

## How to do something useful

1. Look through [the issues on GitHub](https://github.com/moreSwift/swift-cross-ui/issues) and
   choose an issue to work on (or open one if you have an idea)
2. Leave a comment on the issue to let people know that you're working on it
3. Make necessary changes to the codebase
4. Open a PR, making sure to reference the issue that your changes address
5. If a maintainer requests changes, implement the changes
6. A maintainer will merge the changes and the issue can be closed
7. Thank you for improving SwiftCrossUI!

## Before opening a PR

1. Make sure you have documented any new code and updated existing documentation as necessary
2. Make sure that you haven't introduced any new warnings
3. Make sure that the code builds, and the example works correctly
4. If you are adding a new feature, consider adding an example usage of it to the example
5. Run `./Scripts/format_and_lint.sh` (requires installing `swift-format` and `swiftlint`)

## While coding

Here are a few things to keep in mind while working on the code.

1. Do not directly modify a file that has a corresponding `.gyb` template file (which will be in the
   same directory). Instead, modify the template file and then run `./Scripts/generate_gyb.sh`
   to build all of the templates. To learn more about gyb
   [read this post](https://nshipster.com/swift-gyb/)
2. Do not directly modify files in `Sources/Gtk/Generated` or `Sources/Gtk3/Generated`. Update the
   generator at `Sources/GtkCodeGen` instead and run `./Scripts/generate_gtk.sh` to regenerate the
   Gtk 3 and Gtk 4 bindings. If the changes can not be made by updating the generator, pull the
   target file out of `Sources/{Gtk,Gtk3}/Generated` and into `Sources/{Gtk,Gtk3}/Widgets` and
   modify it however you want. Remember to remove the class from `allowListedClasses`,
   `gtk3AllowListedClasses` or `gtk4AllowListedClasses` so that it doesn't get regenerated the
   next time someone runs `./Scripts/generate_gtk.sh`. Alternatively, if possible, add
   code to the generated classes via extensions outside of the Generated directories. I usually
   name these extension files `ClassName+ManualAdditions.swift`.
3. Make sure to avoid massive monolithic commits where possible

## Codestyle

- 4 space tabs
- Add comments to any code you think would need explaining to other contributors
- Document all methods, properties, classes, structs, protocols and enums with documentation
  comments (no matter how trivial, if it's trivial, you can just keep the documentation comment
  short). In Xcode you can press option+cmd+/ when your cursor is on a declaration to autogenerate a
  template documentation comment (it mostly works)
- Avoid using shorthand when the alternative is more readable at a glance
