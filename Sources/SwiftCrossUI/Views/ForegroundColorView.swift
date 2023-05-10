/// A view used to manage a child view's font color. It is preferred to use the `foregroundColor`
/// modifier available on all views (which uses this behind the scenes).
public struct ForegroundColorView<Child: View>: View {
    public var body: ViewContent1<Child>

    public var color: Color

    public init(_ child: Child, color: Color) {
        // TODO: Figure out how to get width working (seems to get ignored)
        body = ViewContent1(child)
        self.color = color
    }

    public func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkBox {
        let box = GtkBox(orientation: .vertical, spacing: 0)
        for widget in children.widgets {
            box.add(widget)
        }

        box.setForegroundColor(states: [.normal], color: color.gtkColor)

        return box
    }

    public func update(_ widget: GtkBox, children: ViewGraphNodeChildren1<Child>) {
        widget.setForegroundColor(states: [.normal], color: color.gtkColor)
    }
}
