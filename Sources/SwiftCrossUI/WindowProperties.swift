/// The basic properties for a window.
public struct WindowProperties {
    /// The window's title.
    public var title: String
    /// The default size of the window.
    public var defaultSize: Size?
    /// Whether or not the window can be resized from the corners.
    public var resizable: Bool

    /// A window size.
    public struct Size {
        public var width: Int
        public var height: Int

        public init(_ width: Int, _ height: Int) {
            self.width = width
            self.height = height
        }
    }

    /// Defines the properties of the current window.
    public init(title: String, defaultSize: Size? = nil, resizable: Bool = true) {
        self.title = title
        self.defaultSize = defaultSize
        self.resizable = resizable
    }
}
