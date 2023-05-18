/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack<Content: ViewContent>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int
    /// The vertical alignment to use for children of the stack.
    private var verticalAlignment: Alignment

    /// Creates a new HStack.
    public init(
        alignment verticalAlignment: Alignment = .center,
        spacing: Int = 8,
        @ViewContentBuilder _ content: () -> Content
    ) {
        body = content()
        self.spacing = spacing
        self.verticalAlignment = verticalAlignment
    }

    public func asWidget(_ children: Content.Children) -> GtkBox {
        let hStack = GtkBox(orientation: .horizontal)
        for widget in children.widgets {
            hStack.add(widget)
        }
        hStack.horizontalAlignment = .fill
        return hStack
    }

    public func update(_ widget: GtkBox, children: Content.Children) {
        widget.spacing = spacing
        widget.verticalAlignment = verticalAlignment.gtkAlignment
    }
}
