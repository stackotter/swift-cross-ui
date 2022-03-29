/// The basic properties for a window.
/// - Parameter title: The window's title.
/// - Parameter defaultWidth: The default width of the window.
/// - Parameter defaultHeight: The default height of the window.
/// - Parameter resizable: Whether or not the window can be resized from the corners.
public struct WindowProperties {
    public var title: String
    public var defaultWidth: Int
    public var defaultHeight: Int
    public var resizable: Bool

    public init(title: String, defaultWidth: Int = 200, defaultHeight: Int = 150, resizable: Bool = true) {
        self.title = title
        self.defaultWidth = defaultWidth
        self.defaultHeight = defaultHeight
        self.resizable = resizable
    }
}
