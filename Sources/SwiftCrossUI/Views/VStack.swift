/// A vertically oriented container. Similar to a `VStack` in SwiftUI.
public struct VStack<Content: ViewContent>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int

    /// Creates a new VStack.
    public init(@ViewContentBuilder _ content: () -> Content, spacing: Int = 8) {
        body = content()
        self.spacing = spacing
    }

    /// Internal initialiser for creating arbitrary VStack's.
    init(_ content: Content) {
        body = content
        spacing = 8
    }

    public func asWidget(_ children: Content.Children) -> GtkBox {
        let vStack = GtkBox(orientation: .vertical)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }

    public func update(_ widget: GtkBox, children: Content.Children) {
        widget.spacing = spacing
    }
}
