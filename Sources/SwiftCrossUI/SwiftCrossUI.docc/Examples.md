# Examples

An overview of the examples included with SwiftCrossUI.

## Overview

A few examples are included with SwiftCrossUI to demonstrate some of it's basic features. These examples are:

- `CounterExample`, a simple app with buttons to increase and decrease a count.
- `RandomNumberGeneratorExample`, a simple app to generate random numbers between a minimum and maximum.
- `GreetingGeneratorExample`, a simple app demonstrating dynamic state and the ``ForEach`` view.
- `SplitExample`, an app showcasing sidebar-based navigation with multiple levels.
- `ControlsExample`, an app showcasing the various types of controls available.
- `WindowingExample`, a simple app showcasing how ``WindowGroup`` is used to make multi-window apps and
  control the properties of each window.
- `NavigationExample`, an app showcasing ``NavigationStack`` and related concepts.
- `SpreadsheetExample`, an app showcasing tables.
- `StressTestExample`, an app used to test view update performance.

To run an example, run the following commands (replacing `[EXAMPLE]` with the name of the example
that you want to run),

```
cd Examples
swift run [EXAMPLE]
```

To try out the examples with another backend, change the value of the `backend` variable
at the top of `Examples/Package.swift` to `GtkBackend`, `QtBackend`, `AppKitBackend`,
`CursesBackend`, or `LVGLBackend`. If you encounter any compilation issues make sure to run
`swift package clean` and try again before you open an issue.

