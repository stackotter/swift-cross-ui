class _App<AppRoot: App> {
    let app: AppRoot
    var viewGraph: ViewGraph<AppRoot>?

    init(_ app: AppRoot) {
        self.app = app
    }

    func run() {
        let gtkApp = GtkApplication(applicationId: app.identifier)

        gtkApp.run { window in
            window.title = self.app.windowProperties.title
            if let size = self.app.windowProperties.defaultSize {
                window.defaultSize = GtkSize(
                    width: size.width,
                    height: size.height
                )
            }
            window.resizable = self.app.windowProperties.resizable

            self.viewGraph = ViewGraph(for: self.app)

            if let widget = self.viewGraph?.rootNode.widget {
                window.setChild(widget)
            }

            window.show()
        }
    }
}
