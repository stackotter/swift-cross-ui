/// An application.
public protocol App {
    associatedtype Content: ViewContent

    /// The application's identifier.
    var identifier: String { get }
    
    /// The contents of the application's main window.
    @ViewBuilder var body: Content { get }
    
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