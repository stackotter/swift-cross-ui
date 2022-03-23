/// An application.
public protocol App {
    associatedtype Content: ViewContent
    associatedtype State: AppState

    /// The application's identifier.
    var identifier: String { get }
    
    /// The application's state.
    var state: State { get }
    
    /// The window's properties.
    var windowProperties: WindowProperties { get }
    
    /// The contents of the application's main window.
    @ViewContentBuilder var body: Content { get }
    
    /// Creates the application.
    init()
}

public class WindowProperties {
    public var title: String
    public var defaultWidth: Int
    public var defaultHeight: Int
    public var resizable: Bool
    
    /// This custom initalizer is used because the default initializer has the 'internal' protection level and can't be accessed from other files.
    /// The window's title is the only required value. All other values will use the previously hard-coded values if not set.
    public init(title: String, defaultWidth: Int? = nil, defaultHeight: Int? = nil, resizable: Bool? = nil)
    {
        self.title = title
        self.defaultWidth = defaultWidth ?? 200
        self.defaultHeight = defaultHeight ?? 150
        self.resizable = resizable ?? true
    }
}

public extension App {
    /// Runs the application.
    static func main() {
        let app = _App(Self())
        app.run()
    }
}

public extension App where State == EmptyAppState {
    var state: State {
        get {
            EmptyAppState()
        } set {
            return
        }
    }
}
