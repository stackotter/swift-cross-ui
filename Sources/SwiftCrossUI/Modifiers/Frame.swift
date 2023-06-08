extension View {
    /// Positions this view within an invisible frame having the specified size constraints.
    public func frame(minWidth: Int? = nil, minHeight: Int? = nil) -> some View {
        return CSSFrameModifierView(
            body: ViewContent1(self),
            minWidth: minWidth,
            minHeight: minHeight
        )
    }
}

/// A view used to manage a child view's size.
private struct CSSFrameModifierView<Child: View>: View {
    var body: ViewContent1<Child>

    var minWidth: Int?
    var minHeight: Int?

    func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkModifierBox {
        let widget = GtkModifierBox().debugName(Self.self)
        widget.setChild(children.child0.widget)
        return widget
    }

    func update(_ widget: GtkModifierBox, children: ViewGraphNodeChildren1<Child>) {
        widget.css.set(properties: [
            .minWidth(minWidth ?? 0),
            .minHeight(minHeight ?? 0)
        ])
    }
}
