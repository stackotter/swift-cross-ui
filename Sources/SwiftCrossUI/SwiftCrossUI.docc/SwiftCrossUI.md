# ``SwiftCrossUI``

Create cross-platform desktop apps for macOS, Linux and Windows.

## Overview

SwiftCrossUI implements a simple API similar but not identical to SwiftUI, allowing you to use the basic concepts of SwiftUI to create a cross-platofrm desktop app. SwiftCrossUI is designed to be flexible and can work with different backends, but has a focus on using GTK+ through SwiftGTK.

## Topics

### Getting Started

- <doc:Basic-Usage>
- <doc:Examples>

### App Structure

The top level of your app.

- ``App``
- ``SceneBuilder``
- ``ViewBuilder``

### Views

The wide variety of views available that you can combine to create complex UIs.

- ``Button``
- ``CellPosition``
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
- ``ViewContent``
- ``VStack``

### States

Objects that are read from and/or written to as part of your app.

- ``State``
- ``Binding``
- ``ObservableObject``
- ``Published``
- ``Publisher``
- ``Cancellable``

### Implementation Details

The detailed components that are part of the low level of SwiftCrossUI.

- ``AnyViewGraphNode``
- ``EitherView``
- ``EmptyView``
- ``EmptyViewChildren``
- ``OptionalView``
- ``TableBuilder``
- ``ViewGraph``
- ``ViewGraphNode``
- ``ViewGraphNodeChildren``
