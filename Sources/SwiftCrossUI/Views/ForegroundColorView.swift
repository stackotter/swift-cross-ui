/// A view used to manage a child view's font color. It is preferred to use the `foregroundColor`
/// modifier available on all views (which uses this behind the scenes).
@available(macOS 99.99.0, *)
public struct ForegroundColorView<Child: View>: View {
    public var body: ViewContentVariadic<Child>

    /// The foreground color to apply to the child view.
    private var color: Color

    public init(_ child: Child, color: Color) {
        body = ViewContentVariadic(child)
        self.color = color
    }

    public func asWidget(_ children: ViewGraphNodeChildrenVariadic<Child>) -> GtkSingleChildBox {
        let box = GtkSingleChildBox()
        box.setChild(children.widgets[0])
        return box
    }

    public func update(_ widget: GtkSingleChildBox, children: ViewGraphNodeChildrenVariadic<Child>) {
        widget.setForegroundColor(color: color.gtkColor)
    }
}
