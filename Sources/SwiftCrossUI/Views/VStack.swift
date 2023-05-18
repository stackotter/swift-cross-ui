/// A vertically oriented container. Similar to a `VStack` in SwiftUI.
public struct VStack<Content: ViewContent>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int
    /// The horizontal alignment to use for children of the stack.
    private var horizontalAlignment: Alignment

    /// Creates a new VStack.
    public init(
        alignment horizontalAlignment: Alignment = .center,
        spacing: Int = 8,
        @ViewContentBuilder _ content: () -> Content
    ) {
        body = content()
        self.spacing = spacing
        self.horizontalAlignment = horizontalAlignment
    }

    /// Internal initialiser for creating arbitrary VStack's.
    init(
        alignment horizontalAlignment: Alignment = .leading,
        spacing: Int = 8,
        _ content: Content
    ) {
        body = content
        self.spacing = spacing
        self.horizontalAlignment = horizontalAlignment
    }

    public func asWidget(_ children: Content.Children) -> GtkBox {
        let vStack = GtkBox(orientation: .vertical)
        for widget in children.widgets {
            vStack.add(widget)
        }
        vStack.expandHorizontally = true
        vStack.horizontalAlignment = .center
        return vStack
    }

    public func update(_ widget: GtkBox, children: Content.Children) {
        for child in children.widgets where !child.prefersFill {
            child.horizontalAlignment = horizontalAlignment.gtkAlignment
        }
        widget.spacing = spacing
    }
}
