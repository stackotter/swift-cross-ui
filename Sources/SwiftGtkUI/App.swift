/// An application.
public protocol App {
    /// The application's identifier.
    var identifier: String { get }
    
    /// The contents of the application's main window.
    @ViewBuilder var body: [View] { get }
    
    /// Creates the application.
    init()
}

public extension App {
    /// Runs the application.
    static func main() {
        let app = Self()
        let gtkApp = GtkApplication(applicationId: app.identifier)
        
        gtkApp.run { window in
            window.title = "Hello, world!"
            window.defaultSize = GtkSize(width: 400, height: 400)
            window.resizable = true
            
            let container = GtkBox(orientation: .vertical, spacing: 8)
            for view in app.body {
                container.add(view.asWidget())
            }
            
            window.add(container)
        }
    }
}
