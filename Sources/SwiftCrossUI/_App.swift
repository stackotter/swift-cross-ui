class _App<AppRoot: App> {
    let app: AppRoot
    var viewGraph: ViewGraph<AppRoot>?

    init(_ app: AppRoot) {
        self.app = app
    }

    func run() {
        let backend = AppRoot.Backend(appIdentifier: app.identifier)
        currentBackend = backend
        backend.run(app) { viewGraph in
            self.viewGraph = viewGraph
        }
    }
}
