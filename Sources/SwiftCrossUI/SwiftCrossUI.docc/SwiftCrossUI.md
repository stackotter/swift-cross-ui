# ``SwiftCrossUI``

Create cross-platform desktop apps for macOS, Linux, Windows, iOS and tvOS.

## Overview

SwiftCrossUI takes inspiration from SwiftUI, allowing you to use the basic concepts of SwiftUI to create cross-platform desktop apps. SwiftCrossUI provides your users with a native experience on every platform via a suite of backends built on top of various UI frameworks (see [Backends](#backends)).

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
