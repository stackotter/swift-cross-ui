import Foundation

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
    /// The most recent size of the window (used when updated the root view due to a state
    /// change as opposed to a window resizing event).
    private var windowSize: SIMD2<Int>

    /// The environment most recently provided by this node's parent scene.
    private var parentEnvironment: Environment

    /// Creates a view graph for a root view with a specific backend.
    public init<Backend: AppBackend>(for view: Root, backend: Backend, environment: Environment) {
        rootNode = AnyViewGraphNode(for: view, backend: backend, environment: environment)

        self.view = view
        windowSize = .zero
        parentEnvironment = environment

        cancellable = view.state.didChange.observe { [weak self] in
            guard let self else { return }
            // TODO: Notify parent scene of the root view's new size (which would be
            //   required to implement content hugging)
            self.update(proposedSize: windowSize, environment: parentEnvironment)
        }
    }

    /// Recomputes the entire UI (e.g. due to the root view's state updating).
    /// If the update is due to the parent scene getting updated then the view
    /// is recomputed and passed as `newView`.
    public func update(
        with newView: Root? = nil,
        proposedSize: SIMD2<Int>,
        environment: Environment
    ) -> ViewUpdateResult {
        parentEnvironment = environment
        windowSize = proposedSize
        return rootNode.update(
            with: newView ?? view,
            proposedSize: proposedSize,
            environment: parentEnvironment
        )
    }

    public func snapshot() -> ViewGraphSnapshotter.NodeSnapshot {
        ViewGraphSnapshotter.snapshot(of: rootNode)
    }
}
