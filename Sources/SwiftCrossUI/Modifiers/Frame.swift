extension View {
    /// Positions this view within an invisible frame having the specified minimum size constraints.
    public func frame(minWidth: Int? = nil, minHeight: Int? = nil) -> some View {
        return FrameView(
            self,
            minWidth: minWidth ?? 0,
            minHeight: minHeight ?? 0
        )
    }
}

/// The implementation for the ``View/frame(minWidth:minHeight:)`` view modifier.
struct FrameView<Child: View>: TypeSafeView {
    var body: VariadicView1<Child>

    /// The minimum width to make the view.
    var minWidth: Int
    /// The minimum height to make the view.
    var minHeight: Int

    /// Wraps a child view with size constraints.
    init(_ child: Child, minWidth: Int, minHeight: Int) {
        self.body = VariadicView1(child)
        self.minWidth = minWidth
        self.minHeight = minHeight
    }

    func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createFrameContainer(for: children.child0.widget.into())
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) {
        backend.updateFrameContainer(widget, minWidth: minWidth, minHeight: minHeight)
    }
}
