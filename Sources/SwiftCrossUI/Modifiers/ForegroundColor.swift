extension View {
    /// Sets the color of the foreground elements displayed by this view.
    public func foregroundColor(_ color: Color) -> some View {
        return ForegroundView(
            self,
            color: color
        )
    }
}

struct ForegroundView<Child: View>: View {
    var body: Child

    var color: Color

    init(_ child: Child, color: Color) {
        self.body = child
        self.color = color
    }

    func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createForegroundColorContainer(
            for: children.child0.widget.into(),
            color: color
        )
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) {
        backend.setForegroundColor(ofForegroundColorContainer: widget, to: color)
    }
}
