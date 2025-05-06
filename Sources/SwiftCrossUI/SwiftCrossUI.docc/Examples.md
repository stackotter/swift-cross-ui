# Examples

An overview of the examples included with SwiftCrossUI.

## Overview

A few examples are included with SwiftCrossUI to demonstrate some of its basic features;

- `CounterExample`, a simple app with buttons to increase and decrease a count.
- `RandomNumberGeneratorExample`, a simple app to generate random numbers between a minimum and maximum.
- `WindowingExample`, a simple app showcasing how ``WindowGroup`` is used to make multi-window apps and
  control the properties of each window.
- `GreetingGeneratorExample`, a simple app demonstrating dynamic state and the ``ForEach`` view.
- `NavigationExample`, an app showcasing ``NavigationStack`` and related concepts.
- `SplitExample`, an app showcasing sidebar-based navigation with multiple levels.
- `StressTestExample`, an app used to test view update performance.
- `SpreadsheetExample`, an app showcasing tables.
- `ControlsExample`, an app showcasing the various types of controls available.

To run an example, either select the example under schemes at the top of the window (in Xcode), or run it from the command line like so:

```
swift run ExampleToRun
```

If you want to try out an example with a backend other than the default, you can do that too;

```
SCUI_DEFAULT_BACKEND=QtBackend swift run ExampleToRun
```
