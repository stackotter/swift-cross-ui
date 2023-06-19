extension View {
    /// Adds a specific padding amount to each edge of this view.
    public func padding(_ amount: Int) -> some View {
        return PaddingModifierView(body: ViewContent1(self), edges: .all, padding: amount)
    }

    /// Adds an equal padding amount to specific edges of this view.
    public func padding(_ edges: Edge.Set, _ amount: Int) -> some View {
        return PaddingModifierView(body: ViewContent1(self), edges: edges, padding: amount)
    }
}

private struct PaddingModifierView<Child: View>: View {
    var body: ViewContent1<Child>

    /// The edges on which to apply padding.
    var edges: Edge.Set
    /// The amount of padding to apply to the child view.
    var padding: Int

    func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkModifierBox {
        let box = GtkModifierBox().debugName(Self.self)
        box.setChild(children.child0.widget)
        return box
    }

    func update(_ box: GtkModifierBox, children: ViewGraphNodeChildren1<Child>) {
        if edges.contains(.top) {
            box.marginTop = padding
        }
        if edges.contains(.bottom) {
            box.marginBottom = padding
        }
        if edges.contains(.leading) {
            box.marginStart = padding
        }
        if edges.contains(.trailing) {
            box.marginEnd = padding
        }
    }
}
