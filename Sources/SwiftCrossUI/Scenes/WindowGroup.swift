#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a group of identically structured windows. Currently
/// only supports having a single instance of the window but will eventually
/// support duplicating the window.
public struct WindowGroup<Content: View>: Scene {
    public typealias Node = WindowGroupNode<Content>

    /// Storing the window group contents lazily allows us to recompute the view
    /// when the window size changes without having to recompute the whole app.
    /// This allows the window group contents to remain linked to the app state
    /// instead of getting frozen in time when the app's body gets evaluated.
    var content: () -> Content

    var body: Content {
        content()
    }

    /// The title of the window (shown in the title bar on most OSes).
    var title: String
    /// The default size of the window (only has effect at time of creation). Defaults to
    /// 900x450.
    var defaultSize: SIMD2<Int>
    /// The window's resizing behaviour.
    var resizability: WindowResizability

    /// Creates a window group optionally specifying a title. Window title defaults
    /// to `ProcessInfo.processInfo.processName`.
    public init(_ title: String? = nil, @ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
        #if os(WASI)
            self.title = title ?? "Title"
        #else
            self.title = title ?? ProcessInfo.processInfo.processName
        #endif
        resizability = .automatic
        defaultSize = SIMD2(900, 450)
    }

    /// Sets the default size of a window (used when creating new instances of the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var windowGroup = self
        windowGroup.defaultSize = SIMD2(width, height)
        return windowGroup
    }

    /// Sets the resizability of a window.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var windowGroup = self
        windowGroup.resizability = resizability
        return windowGroup
    }
}
