/// A type-erased ``ViewGraphNode``. Used by implementations of ``ViewGraphNodeChildren``
/// to avoid leaking the selected backend into ``View`` implementations (which would be
/// an annoying complexity for users of the library and it worth the slight sacrifice
/// in performance and strong-typing). The user never sees such type-erased wrappers.
public class AnyViewGraphNode<NodeView: View> {
    /// The node getting wrapped.
    public var node: Any

    /// The node's widget (type-erased).
    public var widget: AnyWidget {
        _getWidget()
    }

    /// The node's type-erased update method for when the view is recomputed.
    private var _updateWithNewView:
        (
            _ newView: NodeView,
            _ proposedSize: SIMD2<Int>,
            _ parentOrientation: Orientation
        ) -> SIMD2<Int>
    /// The node's type-erased update method for when the view's state changes.
    private var _updateNode:
        (
            _ proposedSize: SIMD2<Int>,
            _ parentOrientation: Orientation
        ) -> SIMD2<Int>
    /// The type-erased getter for the node's widget.
    private var _getWidget: () -> AnyWidget
    /// The type-erased getter for the node's view.
    private var _getNodeView: () -> NodeView
    /// The type-erased getter for the node's children.
    private var _getNodeChildren: () -> any ViewGraphNodeChildren
    /// The underlying erased backend.
    private var _getBackend: () -> any AppBackend

    /// Type-erases a view graph node.
    public init<Backend: AppBackend>(_ node: ViewGraphNode<NodeView, Backend>) {
        self.node = node
        _updateWithNewView = node.update(with:proposedSize:parentOrientation:)
        _updateNode = node.update(proposedSize:parentOrientation:)
        _getWidget = {
            AnyWidget(node.widget)
        }
        _getNodeView = {
            node.view
        }
        _getNodeChildren = {
            node.children
        }
        _getBackend = {
            node.backend
        }
    }

    /// Creates a new view graph node and immediately type-erases it.
    public convenience init<Backend: AppBackend>(
        for view: NodeView,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot? = nil
    ) {
        self.init(ViewGraphNode(for: view, backend: backend, snapshot: snapshot))
    }

    /// Updates the view after it was recomputed (e.g. due to the parent's state changing).
    public func update(
        with newView: NodeView,
        proposedSize: SIMD2<Int>,
        parentOrientation: Orientation
    ) -> SIMD2<Int> {
        _updateWithNewView(newView, proposedSize, parentOrientation)
    }

    /// Updates the view after its state changed.
    public func update(proposedSize: SIMD2<Int>, parentOrientation: Orientation) -> SIMD2<Int> {
        _updateNode(proposedSize, parentOrientation)
    }

    /// Gets the node's wrapped view.
    public func getView() -> NodeView {
        _getNodeView()
    }

    public func getChildren() -> any ViewGraphNodeChildren {
        _getNodeChildren()
    }

    public func getBackend() -> any AppBackend {
        _getBackend()
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
