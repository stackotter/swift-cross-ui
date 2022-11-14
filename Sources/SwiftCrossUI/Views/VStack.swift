/// A vertically oriented container. Similar to a `VStack` in SwiftUI.
public struct VStack<Content: ViewContent>: View {
    public var body: Content
    public var spacing: Int

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
        let vStack = GtkBox(orientation: .vertical, spacing: spacing)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }
}
