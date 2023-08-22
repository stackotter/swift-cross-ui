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
