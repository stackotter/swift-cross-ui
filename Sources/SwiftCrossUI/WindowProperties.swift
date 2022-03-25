/// The basic properties for a window.
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
