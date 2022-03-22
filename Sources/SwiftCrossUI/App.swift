/// An application.
public protocol App {
    associatedtype Content: ViewContent
    associatedtype State: AppState

    /// The application's identifier.
    var identifier: String { get }
    
    /// The application's state.
    var state: State { get }
    
    /// The contents of the application's main window.
    @ViewContentBuilder var body: Content { get }
    
    /// Creates the application.
    init()
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
