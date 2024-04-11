import Foundation

/// A scene that presents a group of identically structured windows. Currently
/// only supports having a single instance of the window but will eventually
/// support duplicating the window.
public struct WindowGroup<Content: View>: Scene {
    public typealias Node = WindowGroupNode<Content>

    var body: Content

    /// The title of the window (shown in the title bar on most OSes).
    var title: String
    /// The default size of the window (only has effect at time of creation).
    var defaultSize: Size?
    /// Whether the window should be resizable.
    var resizable: Bool

    /// Creates a window group optionally specifying a title. Window title defaults
    /// to `ProcessInfo.processInfo.processName`.
    public init(_ title: String? = nil, @ViewBuilder _ content: () -> Content) {
        body = content()
        #if os(WASI)
            self.title = title ?? "Title"
        #else
            self.title = title ?? ProcessInfo.processInfo.processName
        #endif
        resizable = true
    }

    /// Sets the default size of a window (used when creating new instances of the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var windowGroup = self
        windowGroup.defaultSize = Size(width, height)
        return windowGroup
    }

    // TODO: This could possibly be a good place to deviate from the SwiftUI API a bit?
    //   This just isn't that great of an API in my opinion, should just be a boolean flag,
    //   and the modifier should have a more discoverable name.
    /// Sets the resizability of a window. By default windows are resizable.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var windowGroup = self
        windowGroup.resizable = resizability.isResizable
        return windowGroup
    }
}
