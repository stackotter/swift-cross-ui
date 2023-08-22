extension View {
    /// Positions this view within an invisible frame having the specified size constraints.
    public func frame(minWidth: Int? = nil, minHeight: Int? = nil) -> some View {
        return FrameView(
            self,
            minWidth: minWidth ?? 0,
            minHeight: minHeight ?? 0
        )
    }
}

struct FrameView<Child: View>: View {
    var body: ViewContent1<Child>

    var minWidth: Int
    var minHeight: Int

    init(_ child: Child, minWidth: Int, minHeight: Int) {
        self.body = ViewContent1(child)
        self.minWidth = minWidth
        self.minHeight = minHeight
    }

    func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createFrameContainer(
            for: children.child0.widget.into(),
            minWidth: minWidth,
            minHeight: minHeight
        )
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) {
        backend.setMinWidth(ofFrameContainer: widget, to: minWidth)
        backend.setMinHeight(ofFrameContainer: widget, to: minHeight)
    }
}
