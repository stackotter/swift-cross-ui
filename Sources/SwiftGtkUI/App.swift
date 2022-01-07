/// An application.
public protocol App {
    /// Creates the application.
    init()
    
    /// The root view of the application.
    var body: View { get }
}

public extension App {
    /// Runs the application.
    static func main() {
        let app = Self()
        let gtkApp = GtkApplication(applicationId: "dev.stackotter.SwiftGtkUI.Example")
        gtkApp.run { window in
            window.title = "Hello, world!"
            window.defaultSize = GtkSize(width: 400, height: 400)
            window.resizable = true
            
            let box = GtkBox(orientation: .vertical, spacing: 8)
            box.add(app.body)
            window.add(box)
        }
    }
}
