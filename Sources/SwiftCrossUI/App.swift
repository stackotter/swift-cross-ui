import Foundation

/// An application.
public protocol App {
    /// The backend used to render the app.
    associatedtype Backend: AppBackend
    /// The type of scene representing the content of the app.
    associatedtype Body: Scene
    /// The app's observed state.
    associatedtype State: Observable

    /// The application's backend.
    var backend: Backend { get }

    /// The application's state.
    var state: State { get }

    /// The content of the app.
    @SceneBuilder var body: Body { get }

    /// Creates an instance of the app.
    init()
}

/// Force refresh the entire scene graph. Used by hot reloading. If you need to do
/// this in your own code then something has gone very wrong...
public var _forceRefresh: () -> Void = {}

extension App {
    /// Runs the application.
    public static func main() {
        let app = Self()
        let _app = _App(app)
        _forceRefresh = {
            if String(describing: type(of: app.backend)) == "AppKitBackend" {
                DispatchQueue.main.async {
                    _app.forceRefresh()
                }
            } else {
                _app.forceRefresh()
            }
        }
        _app.run()
    }
}

extension App where State == EmptyState {
    public var state: State {
        EmptyState()
    }
}

extension App {
    public var backend: Backend {
        Backend()
    }
}
