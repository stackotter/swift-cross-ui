/// The basic properties for a window.
public struct WindowProperties {
    public var title: String
    public var defaultWidth: Int
    public var defaultHeight: Int
    public var resizable: Bool
    
    /// This custom initalizer is used because the default initializer has the 'internal' protection level and can't be accessed from other files.
    /// The window's title is the only required value. All other values will use the previously hard-coded values if not set.
    public init(title: String, defaultWidth: Int? = nil, defaultHeight: Int? = nil, resizable: Bool? = nil) {
        self.title = title
        self.defaultWidth = defaultWidth ?? 200
        self.defaultHeight = defaultHeight ?? 150
        self.resizable = resizable ?? true
    }
}