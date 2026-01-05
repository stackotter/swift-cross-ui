/// Holds information describing a window.
struct WindowInfo<Content: View> {
    /// The title of the window (shown in the title bar on most OSes).
    var title: String
    /// The default size of the window (only has effect at time of creation).
    /// Defaults to 900x450.
    var defaultSize: SIMD2<Int>
    /// The window's resizing behaviour.
    var resizability: WindowResizability
    /// The window's content.
    var content: () -> Content

    /// Whether the value of `resizability` implies that the window is resizable.
    var isResizable: Bool {
        switch resizability {
            case .automatic, .contentMinSize:
                return true
            case .contentSize:
                return false
        }
    }

    init(
        title: String,
        defaultSize: SIMD2<Int> = SIMD2(900, 450),
        resizability: WindowResizability = .automatic,
        content: @escaping () -> Content
    ) {
        self.title = title
        self.defaultSize = defaultSize
        self.resizability = resizability
        self.content = content
    }
}
