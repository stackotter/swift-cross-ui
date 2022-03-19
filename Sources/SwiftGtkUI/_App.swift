class _App<AppRoot: App> {
    let app: AppRoot
    
    init(_ app: AppRoot) {
        self.app = app
    }
    
    func run() {
        let gtkApp = GtkApplication(applicationId: app.identifier)
        
        gtkApp.run { window in
            window.title = "Hello, world!"
            window.defaultSize = GtkSize(width: 400, height: 400)
            window.resizable = true
            
            let viewGraph = ViewGraph(for: self.app)
            window.add(viewGraph.rootNode.widget)
        }
    }
}
