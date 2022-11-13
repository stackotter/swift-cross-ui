public struct PaddingView<Content: ViewContent>: View {
    public var body: Content
    public var padding: Padding

    init(_ content: Content, _ padding: Padding) {
        body = content
        self.padding = padding
    }

    public func asWidget(_ children: Content.Children) -> GtkBox {
        let box = GtkBox(orientation: .vertical, spacing: 0)
        for widget in children.widgets {
            box.add(widget)
        }

        box.topMargin = padding.top
        box.bottomMargin = padding.bottom
        box.leftMargin = padding.left
        box.rightMargin = padding.right

        return box
    }
}
