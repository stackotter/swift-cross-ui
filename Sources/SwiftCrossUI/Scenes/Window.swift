#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a single window.
public struct Window<Content: View>: Scene {
    public typealias Node = WindowNode<Content>

    public var commands: Commands = .empty

    /// Storing the window contents lazily allows us to recompute the view when
    /// the window size changes without having to recompute the whole app. This
    /// allows the window contents to remain linked to the app state instead of
    /// getting frozen in time when the app's body gets evaluated.
    var content: () -> Content

    var body: Content {
        content()
    }

    /// The title of the window (shown in the title bar on most OSes).
    var title: String
    /// The ID of the window.
    var id: String
    /// The default size of the window (only has effect at time of creation). Defaults to
    /// 900x450.
    var defaultSize: SIMD2<Int>
    /// The window's resizing behaviour.
    var resizability: WindowResizability

    /// Creates a window scene specifying a title and an ID.
    public init(
        _ title: String,
        id: String,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.content = content
        self.title = title
        self.id = id
        resizability = .automatic
        defaultSize = SIMD2(900, 450)
    }

    /// Sets the default size of a window (used when creating new instances of the window).
    public func defaultSize(width: Int, height: Int) -> Self {
        var window = self
        window.defaultSize = SIMD2(width, height)
        return window
    }

    /// Sets the resizability of a window.
    public func windowResizability(_ resizability: WindowResizability) -> Self {
        var window = self
        window.resizability = resizability
        return window
    }
}
