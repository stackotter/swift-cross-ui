class _App<AppRoot: App> {
    let app: AppRoot
    var viewGraph: ViewGraph<AppRoot>?
    
    init(_ app: AppRoot) {
        self.app = app
    }
    
    func run() {
        let gtkApp = GtkApplication(applicationId: app.identifier)
        
        gtkApp.run { window in
            window.title = "Hello, world!"
            window.defaultSize = GtkSize(width: 400, height: 400)
            window.resizable = true
            
            self.viewGraph = ViewGraph(for: self.app)
            
            if let widget = self.viewGraph?.rootNode.widget {
                window.add(widget)
            }
        }
    }
}
