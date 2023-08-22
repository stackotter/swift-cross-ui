public class ViewGraphNode<NodeView: View, Backend: AppBackend> {
    public var widget: Backend.Widget
    public var children: NodeView.Content.Children
    public var view: NodeView
    public var backend: Backend

    private var cancellable: Cancellable?

    public init(for view: NodeView, backend: Backend) {
        let content = view.body
        children = NodeView.Content.Children(from: content, backend: backend)
        self.view = view
        widget = view.asWidget(children, backend: backend)
        self.backend = backend
        update(with: content)

        cancellable = view.state.didChange.observe { [weak self] in
            guard let self = self else { return }
            self.update()
        }
    }

    deinit {
        cancellable?.cancel()
    }

    public func update(with newView: NodeView) {
        var newView = newView
        newView.state = view.state
        view = newView

        update()
    }

    public func update(with content: NodeView.Content? = nil) {
        children.update(with: content ?? view.body, backend: backend)
        view.update(widget, children: children, backend: backend)
        backend.show(widget)
    }
}
