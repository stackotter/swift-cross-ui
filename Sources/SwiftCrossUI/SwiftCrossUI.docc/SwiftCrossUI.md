# ``SwiftCrossUI``

Create cross-platform desktop apps for macOS, Linux and Windows.

## Overview

SwiftCrossUI implements a simple API similar but not identical to SwiftUI, allowing you to use the basic concepts of SwiftUI to create a cross-platofrm desktop app. SwiftCrossUI is designed to be flexible and can work with different backends, but has a focus on using GTK+ through SwiftGTK.

## Topics

### Getting Started

- <doc:Basic-Usage>
- <doc:Examples>

### App Structure

The top level of your app

- ``App``
- ``SceneBuilder``
- ``ViewBuilder``

### Views

SwiftCrossUI has a wide variety of views available that you can combine to create complex UIs.

- ``Button``
- ``Color``
- ``ForEach``
- ``HStack``
- ``Image``
- ``NavigationLink``
- ``NavigationPath``
- ``NavigationSplitView``
- ``NavigationStack``
- ``Picker``
- ``ScrollView``
- ``Slider``
- ``Spacer``
- ``Table``
- ``TableColumn``
- ``Text``
- ``TextField``
- ``Toggle``
- ``View``
- ``VStack``

### States

- ``AppState``
- ``Binding``
- ``Cancellable``
- ``EmptyAppState``
- ``EmptyState``
- ``EmptyViewState``
- ``Observable``
- ``Observed``
- ``Publisher``
- ``ViewState``

### Implementation Details

- ``AnyViewGraphNode``
- ``ViewGraph``
- ``ViewGraphNode``
- ``ViewGraphNodeChildren``