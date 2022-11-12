/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack<Content: ViewContent>: View {
    public var body: Content
    public var spacing: Int

    /// Creates a new HStack.
    public init(@ViewContentBuilder _ content: () -> Content, spacing: Int = 8) {
        body = content()
        self.spacing = spacing
    }

    public func asWidget(_ children: Content.Children) -> GtkWidget {
        let hStack = GtkBox(orientation: .horizontal, spacing: spacing)
        for widget in children.widgets {
            hStack.add(widget)
        }
        return hStack
    }
}
