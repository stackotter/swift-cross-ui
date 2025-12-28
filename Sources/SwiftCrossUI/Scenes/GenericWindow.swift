#if !os(WASI)
    import Foundation
#endif

/// A scene that presents a single window. Used in the implementation of
/// window-based scenes such as ``Window`` and ``WindowGroup``.
struct GenericWindow<Content: View>: Scene {
    typealias Node = GenericWindowNode<Content>

    var commands: Commands = .empty

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
    /// The ID of the window, if any.
    var id: String?
    /// The default size of the window (only has effect at time of creation).
    /// Defaults to 900x450.
    var defaultSize: SIMD2<Int>
    /// The window's resizing behaviour.
    var resizability: WindowResizability
    /// Whether to open the window on app launch.
    var openOnAppLaunch: Bool

    /// Creates a generic window scene specifying a title and an ID.
    init(
        _ title: String,
        id: String?,
        openOnAppLaunch: Bool = false,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.content = content
        self.title = title
        self.id = id
        self.openOnAppLaunch = openOnAppLaunch
        resizability = .automatic
        defaultSize = SIMD2(900, 450)
    }
}
