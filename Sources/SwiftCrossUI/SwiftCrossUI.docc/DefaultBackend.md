# DefaultBackend

An adaptive backend which uses different backends under the hood depending on the target operating system.

## Overview

The beauty of SwiftCrossUI is that you can write your app once and have it look native everywhere. For this reason I recommend using `DefaultBackend` unless you've got particular constraints. On macOS it uses `AppKitBackend`, on Windows it uses `WinUIBackend`, on Linux it uses `GtkBackend`, and on iOS and tvOS it uses `UIKitBackend`.
