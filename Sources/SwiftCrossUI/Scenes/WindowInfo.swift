/// Holds information describing a window.
struct WindowInfo<Content: View> {
    /// The title of the window (shown in the title bar on most OSes).
    var title: String
    /// The window's content.
    var content: () -> Content

    init(
        title: String,
        content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }
}
