import Foundation

/// A view that can be displayed by SwiftGtkUI.
public protocol View {
    associatedtype Content: ViewContent
    associatedtype Model: ViewModel
    
    var model: Model { get set }

    /// The view's contents.
    @ViewContentBuilder var body: Content { get }
    
    func asWidget(_ children: Content.Children) -> GtkWidget
    
    func update(_ widget: GtkWidget, children: Content.Children)
}

public extension View {
    func asWidget(_ children: Content.Children) -> GtkWidget {
        let vStack = GtkBox(orientation: .vertical, spacing: 8)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }
    
    func update(_ widget: GtkWidget, children: Content.Children) {}
}

public extension View where Model == EmptyViewModel {
    var model: Model {
        get {
            EmptyViewModel()
        } set {
            return
        }
    }
}
