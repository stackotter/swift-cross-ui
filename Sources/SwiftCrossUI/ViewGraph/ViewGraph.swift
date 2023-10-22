/// The root of the view graph which shadows the app's view structure with extra metadata,
/// cross-update state persistence, and behind the scenes backend widget handling. This is
/// where state updates are propagated through the view hierarchy, and also where view bodies
/// get recomputed.
public class ViewGraph<Root: App> {
    /// The view graph's
    public typealias RootNode = ViewGraphNode<Root.Content, Root.Backend>

    /// The root node storing the node for the app's body.
    public var rootNode: RootNode
    /// A cancellable handle to the app's state observation.
    private var cancellable: Cancellable?
    /// The app being managed by this view graph.
    private var app: Root

    /// Creates a view graph for an app along with an instance of a compatible backend.
    public init(for app: Root, backend: Root.Backend) {
        rootNode = ViewGraphNode(for: app.body, backend: backend)

        self.app = app

        cancellable = app.state.didChange.observe {
            self.update()
        }
    }

    /// Recomputes the entire UI (e.g. due to the app's state updating).
    public func update() {
        rootNode.update(with: app.body)
    }
}
