@available(macOS 99.99.0, *)
public struct PaddingView<Child: View>: View {
    public var body: ViewContentVariadic<Child>

    /// The padding to apply to the child view.
    private var padding: Padding

    init(_ content: Child, _ padding: Padding) {
        body = ViewContentVariadic(content)
        self.padding = padding
    }

    public func asWidget(_ children: ViewGraphNodeChildrenVariadic<Child>) -> GtkSingleChildBox {
        let box = GtkSingleChildBox()
        box.setChild(children.widgets[0])
        return box
    }

    public func update(_ box: GtkSingleChildBox, children: ViewGraphNodeChildrenVariadic<Child>) {
        box.topMargin = padding.top
        box.bottomMargin = padding.bottom
        box.leftMargin = padding.left
        box.rightMargin = padding.right
    }
}
