// TODO: This could possibly be renamed to ``SceneGraph`` now that that's basically the role
//   it has taken on since introducing scenes.
/// A top-level wrapper providing an entry point for the app. Exists to be able to persist
/// the view graph alongside the app (we can't do that on a user's `App` implementation because
/// we can only add computed properties).
class _App<AppRoot: App> {
    /// The app being run.
    let app: AppRoot
    /// An instance of the app's selected backend.
    let backend: AppRoot.Backend
    /// The root of the app's scene graph.
    var sceneGraphRoot: AppRoot.Body.Node?
    /// A cancellable handle to observation of the app's state .
    var cancellable: Cancellable?

    /// Wraps a user's app implementation.
    init(_ app: AppRoot) {
        backend = AppRoot.Backend(appIdentifier: app.identifier)
        self.app = app
    }

    func forceRefresh() {
        self.sceneGraphRoot?.update(self.app.body, backend: self.backend)
    }

    /// Runs the app using the app's selected backend.
    func run() {
        currentBackend = backend
        backend.runMainLoop {
            let rootNode = AppRoot.Body.Node(
                from: self.app.body,
                backend: self.backend
            )

            rootNode.update(nil, backend: self.backend)
            self.sceneGraphRoot = rootNode

            self.cancellable = self.app.state.didChange.observe {
                self.sceneGraphRoot?.update(self.app.body, backend: self.backend)
            }
        }
    }
}
