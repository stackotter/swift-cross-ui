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

    // This custom initializer is used to insure that it is public instead of "internal".
    /// Defines the properties of the current window.
    public init(title: String, defaultWidth: Int = 200, defaultHeight: Int = 150, resizable: Bool = true) {
        self.title = title
        self.defaultWidth = defaultWidth
        self.defaultHeight = defaultHeight
        self.resizable = resizable
    }
}
