/// A type-erased ``ViewGraphNode``. Used by implementations of ``ViewGraphNodeChildren``
/// to avoid leaking the selected backend into ``View`` implementations (which would be
/// an annoying complexity for users of the library and it worth the slight sacrifice
/// in performance and strong-typing). The user never sees such type-erased wrappers.
public class AnyViewGraphNode<NodeView: View> {
    /// The number getting wrapped.
    public var node: Any

    /// The node's widget (type-erased).
    public var widget: AnyWidget {
        getWidget()
    }

    /// The node's type-erased update method for when the view is recomputed.
    private var updateWithNewView: (NodeView) -> Void
    /// The node's type-erased update method for when the view's state changes.
    private var updateNode: () -> Void
    /// The type-erased getter for the node's widget.
    private var getWidget: () -> AnyWidget

    /// Type-erases a view graph node.
    public init<Backend: AppBackend>(_ node: ViewGraphNode<NodeView, Backend>) {
        self.node = node
        updateWithNewView = node.update(with:)
        updateNode = node.update
        getWidget = {
            return AnyWidget(node.widget)
        }
    }

    /// Creates a new view graph node and immediately type-erases it.
    public convenience init<Backend: AppBackend>(for view: NodeView, backend: Backend) {
        self.init(ViewGraphNode(for: view, backend: backend))
    }

    /// Updates the view after it was recomputed (e.g. due to the parent's state changing).
    public func update(with newView: NodeView) {
        updateWithNewView(newView)
    }

    /// Updates the view after its state changed.
    public func update() {
        updateNode()
    }

    /// Converts the node back to its original type. Crashes if the requested backend doesn't
    /// match the node's original backend.
    public func concreteNode<Backend: AppBackend>(
        for backend: Backend.Type
    ) -> ViewGraphNode<NodeView, Backend> {
        guard let node = node as? ViewGraphNode<NodeView, Backend> else {
            fatalError("AnyViewGraphNode used with incompatible backend \(backend)")
        }
        return node
    }
}
