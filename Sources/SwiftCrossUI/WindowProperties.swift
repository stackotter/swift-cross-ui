/// The basic properties for a window.
public struct WindowProperties {
    /// The window's title.
    public var title: String
    /// The default width of the window.
    public var defaultWidth: Int
    /// The default height of the window.
    public var defaultHeight: Int
    /// Whether or not the window can be resized from the corners.
    public var resizable: Bool

    /// Defines the properties of the current window.
    public init(title: String, defaultWidth: Int = 300, defaultHeight: Int = 300, resizable: Bool = true) {
        self.title = title
        self.defaultWidth = defaultWidth
        self.defaultHeight = defaultHeight
        self.resizable = resizable
    }
}
