/// An application.
public protocol App {
    /// The backend used to render the app.
    associatedtype Backend: AppBackend
    /// The app's top-level content.
    associatedtype Content: View
    /// The app's observed state.
    associatedtype State: Observable

    /// The application's identifier.
    var identifier: String { get }

    /// The application's state.
    var state: State { get }

    /// The window's properties.
    var windowProperties: WindowProperties { get }

    /// The contents of the app's main window.
    @ViewBuilder var body: Content { get }

    /// Creates an instance of the app.
    init()
}

extension App {
    /// Runs the application.
    public static func main() {
        let app = _App(Self())
        app.run()
    }
}

extension App where State == EmptyState {
    public var state: State {
        EmptyState()
    }
}
