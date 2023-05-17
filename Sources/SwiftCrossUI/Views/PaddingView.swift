public struct PaddingView<Child: View>: View {
    public var body: ViewContent1<Child>
    public var padding: Padding

    init(_ content: Child, _ padding: Padding) {
        body = ViewContent1(content)
        self.padding = padding
    }

    public func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkSingleChildBox {
        let box = GtkSingleChildBox()
        box.setOnlyChild(children.child0.widget)

        box.topMargin = padding.top
        box.bottomMargin = padding.bottom
        box.leftMargin = padding.left
        box.rightMargin = padding.right

        return box
    }

    public func update(_ box: GtkSingleChildBox, children: ViewGraphNodeChildren1<Child>) {
        box.topMargin = padding.top
        box.bottomMargin = padding.bottom
        box.leftMargin = padding.left
        box.rightMargin = padding.right
    }
}
