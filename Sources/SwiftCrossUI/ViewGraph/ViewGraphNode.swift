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
        if let container = view.asContainerView(backend: backend) {
            children = container.asChildren()
        } else if NodeView.Content.self == EmptyView.self {
            children = EmptyViewGraphNodeChildren()
        } else {
            children = ViewGraphNodeChildren1(view.body, backend: backend)
        }

        // Then create the widget for the view itself
        widget = view.asWidget(
            children.widgets.map { $0.into() },
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
        if let containerView = view.asContainerView(backend: backend) {
            containerView.updateChildren(children)
        } else if NodeView.Content.self != EmptyView.self {
            guard let children = children as? ViewGraphNodeChildren1<NodeView.Content> else {
                fatalError("Invalid children for non-container view (supposedly unreachable)")
            }
            children.child0.update(with: view.body)
        }
        view.update(widget, children: children.widgets.map { $0.into() }, backend: backend)
        backend.show(widget)
    }
}
