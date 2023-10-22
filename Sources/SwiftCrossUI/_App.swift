/// A top-level wrapper providing an entry point for the app. Exists to be able to persist
/// the view graph alongside the app (we can't do that on a user's `App` implementation because
/// we can only add computed properties).
class _App<AppRoot: App> {
    /// The app being run.
    let app: AppRoot
    /// The app's view graph.
    var viewGraph: ViewGraph<AppRoot>?

    /// Wraps a user's app implementation.
    init(_ app: AppRoot) {
        self.app = app
    }

    /// Runs the app using the app's selected backend.
    func run() {
        let backend = AppRoot.Backend(appIdentifier: app.identifier)
        currentBackend = backend
        backend.run(app) { viewGraph in
            self.viewGraph = viewGraph
        }
    }
}
