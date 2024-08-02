#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a group of identically structured windows. Currently
/// only supports having a single instance of the window but will eventually
/// support duplicating the window.
public struct WindowGroup<Content: View>: Scene {
    public typealias Node = WindowGroupNode<Content>

    var body: Content

    /// The title of the window (shown in the title bar on most OSes).
    var title: String
    /// The default size of the window (only has effect at time of creation). Defaults to
    /// 900x450.
    var defaultSize: SIMD2<Int>
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
        defaultSize = SIMD2(900, 450)
    }

    /// Sets the default size of a window (used when creating new instances of the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var windowGroup = self
        windowGroup.defaultSize = SIMD2(width, height)
        return windowGroup
    }

    /// Sets the resizability of a window. By default windows are resizable.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var windowGroup = self
        windowGroup.resizable = resizability.isResizable
        return windowGroup
    }
}
