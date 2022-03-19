/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack<Content: ViewContent>: View {
    public var model = EmptyViewModel()
    
    public var body: Content
    
    /// Creates a new HStack.
    public init(@ViewContentBuilder _ content: () -> Content) {
        body = content()
    }
    
    public func asWidget(_ children: Content.Children) -> GtkWidget {
        let hStack = GtkBox(orientation: .horizontal, spacing: 8)
        for widget in children.widgets {
            hStack.add(widget)
        }
        return hStack
    }
}
