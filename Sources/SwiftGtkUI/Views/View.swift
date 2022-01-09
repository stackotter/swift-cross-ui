/// A view that can be displayed by SwiftGtkUI.
public protocol View {
    /// The view's child components.
    @ViewBuilder var body: [View] { get }
    
    /// Converts the view to a Gtk widget for rendering.
    ///
    /// By default, a view's contents are just put into a VStack.
    func asWidget() -> GtkWidget
}

public extension View {
    func asWidget() -> GtkWidget {
        let container = GtkBox(orientation: .vertical, spacing: 8)
        for view in body {
            container.add(view.asWidget())
        }
        return container
    }
}

