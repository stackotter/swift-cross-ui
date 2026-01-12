/// Holds information describing a window.
struct WindowInfo<Content: View> {
    /// The title of the window (shown in the title bar on most OSes).
    var title: String
    /// The default size of the window (only has effect at time of creation).
    /// Defaults to 900x450.
    var defaultSize: SIMD2<Int>
    /// The window's content.
    var content: () -> Content

    init(
        title: String,
        defaultSize: SIMD2<Int> = SIMD2(900, 450),
        content: @escaping () -> Content
    ) {
        self.title = title
        self.defaultSize = defaultSize
        self.content = content
    }
}
