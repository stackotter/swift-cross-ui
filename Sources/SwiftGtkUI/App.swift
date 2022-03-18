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
        let app = _App(Self())
        app.run()
    }
}

struct _ViewGraphNode {
    var widget: GtkWidget
    var children: [_ViewGraphNode]
    
    static func build(from view: View) -> _ViewGraphNode {
        if let view = view as? _View {
            return view.build()
        }
        
        let vStack = VStack(view.body)
        return vStack.build()
    }
    
    static func update(_ node: inout _ViewGraphNode, view: View) {
        if let view = view as? _View {
            view.update(&node)
        } else {
            let vStack = VStack(view.body)
            vStack.update(&node)
        }
    }
}

class _App<AppRoot: App> {
    let app: AppRoot
    
    init(_ app: AppRoot) {
        self.app = app
    }
    
    static func build(_ app: App) -> _ViewGraphNode {
        let vStack = VStack(app.body)
        return vStack.build()
    }
    
    static func update(_ rootNode: inout _ViewGraphNode, app: App) {
        let vStack = VStack(app.body)
        vStack.update(&rootNode)
    }
    
    func run() {
        let gtkApp = GtkApplication(applicationId: app.identifier)
        
        gtkApp.run { window in
            window.title = "Hello, world!"
            window.defaultSize = GtkSize(width: 400, height: 400)
            window.resizable = true
            
            var rootNode = Self.build(self.app)
            
            let button = GtkButton()
            button.label = "Refresh"
            button.clicked = { _ in
                print("Clicked")
                Self.update(&rootNode.children[0], app: self.app)
            }
            
            (rootNode.widget as? GtkBox)?.add(button)
            
            window.add(rootNode.widget)
        }
    }
}
