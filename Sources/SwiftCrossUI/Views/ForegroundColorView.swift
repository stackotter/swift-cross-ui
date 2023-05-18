/// A view used to manage a child view's font color. It is preferred to use the `foregroundColor`
/// modifier available on all views (which uses this behind the scenes).
public struct ForegroundColorView<Child: View>: View {
    public var body: ViewContent1<Child>

    public var color: Color

    public init(_ child: Child, color: Color) {
        body = ViewContent1(child)
        self.color = color
    }

    public func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkSingleChildBox {
        let box = GtkSingleChildBox()
        box.setChild(children.child0.widget)
        return box
    }

    public func update(_ widget: GtkSingleChildBox, children: ViewGraphNodeChildren1<Child>) {
        widget.setForegroundColor(color: color.gtkColor)
    }
}
