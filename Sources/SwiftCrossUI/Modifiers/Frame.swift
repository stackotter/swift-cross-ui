extension View {
    /// Positions this view within an invisible frame having the specified size constraints.
    public func frame(minWidth: Int? = nil, minHeight: Int? = nil) -> some View {
        return SimpleFrameModifierView(
            body: ViewContent1(self),
            minWidth: minWidth,
            minHeight: minHeight
        )
    }

    // TODO: For max and ideal we need constraints, but there are 0 tutorials on how to use these
    // ConstraintRelation has less than, equal, greater than: https://docs.gtk.org/gtk4/enum.ConstraintRelation.html
    // gtk_constraint_new even allows for `strength` so maybe we can allow Text to expand with low strength.
    //
    // public func frame(
    //     minimumHeight: Int? = nil,
    //     maximumHeight: Int? = nil
    // ) -> some View {
    //     return FrameModifierView(
    //         ViewContent1(self),
    //         minimumWidth: Int?,
    //         maximumWidth: Int?,
    //         minimumHeight: minimumHeight,
    //         maximumHeight: Int?
    //     )
    // }
}

/// A view used to manage a child view's size.
private struct SimpleFrameModifierView<Child: View>: View {
    var body: ViewContent1<Child>

    var minWidth: Int?
    var minHeight: Int?

    func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkSingleChildBox {
        let widget = GtkSingleChildBox()
        widget.setChild(children.child0.widget)
        return widget
    }

    func update(_ widget: GtkSingleChildBox, children: ViewGraphNodeChildren1<Child>) {
        widget.sizeRequest = (minWidth ?? -1, minHeight ?? -1)
    }
}
