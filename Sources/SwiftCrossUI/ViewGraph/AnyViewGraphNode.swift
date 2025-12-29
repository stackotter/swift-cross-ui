/// A type-erased ``ViewGraphNode``. Used by implementations of ``ViewGraphNodeChildren``
/// to avoid leaking the selected backend into ``View`` implementations (which would be
/// an annoying complexity for users of the library and it worth the slight sacrifice
/// in performance and strong-typing). The user never sees such type-erased wrappers.
@MainActor
public class AnyViewGraphNode<NodeView: View> {
    /// The node getting wrapped.
    public var node: Any

    /// The node's widget (type-erased).
    public var widget: AnyWidget {
        _getWidget()
    }

    /// The node's type-erased update method for update the view.
    private var _updateWithNewView:
        (
            _ newView: NodeView?,
            _ proposedSize: SIMD2<Int>,
            _ environment: EnvironmentValues,
            _ dryRun: Bool
        ) -> ViewUpdateResult
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
        _updateWithNewView = node.update(with:proposedSize:environment:dryRun:)
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
        snapshot: ViewGraphSnapshotter.NodeSnapshot? = nil,
        environment: EnvironmentValues
    ) {
        self.init(
            ViewGraphNode(
                for: view,
                backend: backend,
                snapshot: snapshot,
                environment: environment
            )
        )
    }

    /// Updates the view after it got recomputed (e.g. due to the parent's state
    /// changing) or after its own state changed (depending on the presence of
    /// `newView`).
    ///
    /// - Parameters:
    ///   - newView: The recomputed view.
    ///   - proposedSize: The view's proposed size.
    ///   - environment: The current environment.
    ///   - dryRun: If `true`, only compute sizing and don't update the
    ///     underlying widget.
    /// - Returns: The result of updating the view.
    public func update(
        with newView: NodeView?,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        dryRun: Bool
    ) -> ViewUpdateResult {
        _updateWithNewView(newView, proposedSize, environment, dryRun)
    }

    /// Gets the node's wrapped view.
    ///
    /// - Returns: The node's wrapped view.
    public func getView() -> NodeView {
        _getNodeView()
    }

    /// Gets the node's children.
    ///
    /// - Returns: The node's children.
    public func getChildren() -> any ViewGraphNodeChildren {
        _getNodeChildren()
    }

    /// Gets the node's backend.
    ///
    /// - Returns: The node's backend.
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
