public class ViewGraphNode<NodeView: View, Backend: AppBackend> {
    public var widget: Backend.Widget
    public var children: any ViewGraphNodeChildren
    public var view: NodeView
    public var backend: Backend

    private var cancellable: Cancellable?

    public init(for view: NodeView, backend: Backend) {
        self.view = view
        self.backend = backend

        // First create the view's child nodes and widgets
        children = view.asChildren(backend: backend)

        // Then create the widget for the view itself
        widget = view.asWidget(
            children,
            backend: backend
        )

        // Now update to ensure that orientations of layout-transparent containers can propagate
        update()

        // Update the view and its children when state changes (children are always updated first)
        cancellable = view.state.didChange.observe { [weak self] in
            guard let self = self else { return }
            self.update()
        }
    }

    deinit {
        cancellable?.cancel()
    }

    /// Replaces the view with a new version created while recomputing the body of its parent
    /// (e.g. when its parent's state updates).
    public func update(with newView: NodeView) {
        var newView = newView
        newView.state = view.state
        view = newView

        update()
    }

    /// Recomputes the view's body and updates its children and widget accordingly.
    public func update() {
        view.updateChildren(children, backend: backend)
        view.update(widget, children: children, backend: backend)
        backend.show(widget)
    }
}
