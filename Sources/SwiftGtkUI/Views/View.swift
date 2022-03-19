import Foundation

/// A view that can be displayed by SwiftGtkUI.
public protocol View {
    associatedtype Content: ViewContent
    associatedtype Model: ViewModel
    
    /// The view's state model.
    var model: Model { get }

    /// The view's contents.
    @ViewContentBuilder var body: Content { get }
    
    func asWidget(_ children: Content.Children) -> GtkWidget
    
    func update(_ widget: GtkWidget)
}

public extension View {
    func asWidget(_ children: Content.Children) -> GtkWidget {
        let vStack = GtkBox(orientation: .vertical, spacing: 8)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }
    
    func update(_ widget: GtkWidget) {}
}
