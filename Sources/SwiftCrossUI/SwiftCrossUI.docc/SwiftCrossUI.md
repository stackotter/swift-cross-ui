# ``SwiftCrossUI``

Create cross-platform desktop apps for macOS, Linux and Windows.

## Overview

SwiftCrossUI implements a simple API similar but not identical to SwiftUI, allowing you to use the basic concepts of SwiftUI to create a cross-platofrm desktop app. SwiftCrossUI is designed to be flexible and can work with different backends, but has a focus on using GTK+ through SwiftGTK.

## Topics

### Getting Started

- <doc:Quick-Start>
- <doc:Examples>

### Backends

SwiftCrossUI has a variety of backends tailored to different operating systems. The beauty of SwiftCrossUI is that you can write your app once and have it look native everywhere. For this reason I recommend using `DefaultBackend` unless you've got particular constraints.

- <doc:DefaultBackend>
- <doc:AppKitBackend>
- <doc:UIKitBackend>
- <doc:WinUIBackend>
- <doc:GtkBackend>
- <doc:Gtk3Backend>

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
