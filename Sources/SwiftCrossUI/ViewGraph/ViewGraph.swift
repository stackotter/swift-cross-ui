/// The root of the view graph which shadows a root view's structure with extra metadata,
/// cross-update state persistence, and behind the scenes backend widget handling.
///
/// This is where state updates are propagated through the view hierarchy, and also where view
/// bodies get recomputed. The root node is type-erased because otherwise the selected backend
/// would have to get propagated through the entire scene graph which would leak it into
/// ``Scene`` implementations (exposing users to unnecessary internal details).
public class ViewGraph<Root: View> {
    /// The view graph's
    public typealias RootNode = AnyViewGraphNode<Root>

    /// The root node storing the node for the root view's body.
    public var rootNode: RootNode
    /// A cancellable handle to observation of the view's state.
    private var cancellable: Cancellable?
    /// The root view being managed by this view graph.
    private var view: Root

    /// Creates a view graph for a root view with a specific backend.
    public init<Backend: AppBackend>(for view: Root, backend: Backend) {
        rootNode = AnyViewGraphNode(for: view, backend: backend)

        self.view = view

        cancellable = view.state.didChange.observe {
            self.update()
        }
    }

    /// Recomputes the entire UI (e.g. due to the root view's state updating).
    /// If the update is due to the parent scene getting updated then the view]
    /// is recomputed and passed as `newView`.
    public func update(_ newView: Root? = nil) {
        rootNode.update(with: newView ?? view)
    }
}
