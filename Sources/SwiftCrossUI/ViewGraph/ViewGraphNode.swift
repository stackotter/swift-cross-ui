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
        widget.show()
    }
}

public class AnyViewGraphNode<NodeView: View> {
    public var node: Any
    public var widget: AnyWidget {
        _getWidget()
    }
    public var _updateWithNewView: (NodeView) -> Void
    public var _updateWithContent: (NodeView.Content?) -> Void
    public var _getWidget: () -> AnyWidget

    public init<Backend: AppBackend>(_ node: ViewGraphNode<NodeView, Backend>) {
        self.node = node
        _updateWithNewView = node.update(with:)
        _updateWithContent = node.update(with:)
        _getWidget = {
            return AnyWidget(node.widget)
        }
    }

    public convenience init<Backend: AppBackend>(for view: NodeView, backend: Backend) {
        self.init(ViewGraphNode(for: view, backend: backend))
    }

    public func update(with newView: NodeView) {
        _updateWithNewView(newView)
    }

    public func update(with content: NodeView.Content? = nil) {
        _updateWithContent(content)
    }

    public func concreteNode<Backend: AppBackend>(
        for backend: Backend.Type
    ) -> ViewGraphNode<NodeView, Backend> {
        guard let node = node as? ViewGraphNode<NodeView, Backend> else {
            fatalError("AnyViewGraphNode used with incompatible backend \(backend)")
        }
        return node
    }
}

public class AnyWidget {
    var widget: Any

    public init(_ widget: Any) {
        self.widget = widget
    }

    public func concreteWidget<Backend: AppBackend>(
        for backend: Backend.Type
    ) -> Backend.Widget {
        guard let widget = widget as? Backend.Widget else {
            fatalError("AnyWidget used with incompatible backend \(backend)")
        }
        return widget
    }

    public func into<T>() -> T {
        guard let widget = widget as? T else {
            fatalError("AnyWidget used with incompatible widget type \(T.self)")
        }
        return widget
    }
}
