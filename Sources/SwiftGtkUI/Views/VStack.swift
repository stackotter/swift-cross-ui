/// A vertically oriented container. Similar to a `VStack` in SwiftUI.
public struct VStack<Content: ViewContent>: View {
    public var model = EmptyViewModel()
    
    public var body: Content
    
    /// Creates a new VStack.
    public init(@ViewContentBuilder _ content: () -> Content) {
        body = content()
    }
    
    /// Internal initialiser for creating arbitrary VStack's.
    init(_ content: Content) {
        body = content
    }
    
    public func asWidget(_ children: Content.Children) -> GtkWidget {
        let vStack = GtkBox(orientation: .vertical, spacing: 8)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }
}
