/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack<Content: ViewContent>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int

    /// Creates a new HStack.
    public init(spacing: Int = 8, @ViewContentBuilder _ content: () -> Content) {
        body = content()
        self.spacing = spacing
    }

    public func asWidget(_ children: Content.Children) -> GtkBox {
        let hStack = GtkBox(orientation: .horizontal)
        for widget in children.widgets {
            hStack.add(widget)
        }
        return hStack
    }

    public func update(_ widget: GtkBox, children: Content.Children) {
        widget.spacing = spacing
    }
}
