class _App<AppRoot: App> {
    let app: AppRoot
    var viewGraph: ViewGraph<AppRoot>?
    
    init(_ app: AppRoot) {
        self.app = app
    }
    
    func run() {
        let gtkApp = GtkApplication(applicationId: app.identifier)
        
        gtkApp.run { window in
            /// The title of the window.
            window.title = self.app.windowProperties.title
            /// The default width and height of the window.
            window.defaultSize = GtkSize(
                width: self.app.windowProperties.defaultWidth,
                height: self.app.windowProperties.defaultHeight)
            /// Whether or not the window's size can be changed.
            window.resizable = self.app.windowProperties.resizable
            
            self.viewGraph = ViewGraph(for: self.app)
            
            if let widget = self.viewGraph?.rootNode.widget {
                window.add(widget)
            }
        }
    }
}
