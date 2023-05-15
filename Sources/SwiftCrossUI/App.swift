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

extension App {
    /// Runs the application.
    public static func main() {
        let app = _App(Self())
        app.run()
    }
}

extension App where State == EmptyAppState {
    public var state: State {
        EmptyAppState()
    }
}
