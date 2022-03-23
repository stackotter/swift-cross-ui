class _App<AppRoot: App> {
    let app: AppRoot
    var viewGraph: ViewGraph<AppRoot>?
    
    init(_ app: AppRoot) {
        self.app = app
    }
    
    func run() {
        let gtkApp = GtkApplication(applicationId: app.identifier)
        
        gtkApp.run { window in
            window.title = self.app.windowTitle
            //window.title = "Hello, world!"
            window.defaultSize = GtkSize(width: 200, height: 150)
            window.resizable = true
            
            self.viewGraph = ViewGraph(for: self.app)
            
            if let widget = self.viewGraph?.rootNode.widget {
                window.add(widget)
            }
        }
    }
}
