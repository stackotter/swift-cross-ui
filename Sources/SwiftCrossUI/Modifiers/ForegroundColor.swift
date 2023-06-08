extension View {
    /// Sets the color of the foreground elements displayed by this view.
    public func foregroundColor(_ color: Color) -> some View {
        return ForegroundColorModifierView(body: ViewContent1(self), color: color)
    }
}

private struct ForegroundColorModifierView<Child: View>: View {
    var body: ViewContent1<Child>

    /// The foreground color to apply to the child view.
    var color: Color

    func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkModifierBox {
        let box = GtkModifierBox().debugName(Self.self)
        box.setChild(children.child0.widget)
        return box
    }

    func update(_ widget: GtkModifierBox, children: ViewGraphNodeChildren1<Child>) {
        widget.css.set(property: .foregroundColor(color.gtkColor))
    }
}
