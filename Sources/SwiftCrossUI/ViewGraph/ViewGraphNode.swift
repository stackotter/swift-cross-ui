/// A view graph node storing a view, its widget, and its children (likely a collection of more nodes).
///
/// This is where updates are initiated when a view's state updates, and where state is persisted
/// even when a view gets recomputed by its parent.
public class ViewGraphNode<NodeView: View, Backend: AppBackend> {
    /// The view's single widget for the entirety of its lifetime in the view graph.
    public let widget: Backend.Widget
    /// The view's children (usually just contains more view graph nodes, but can handle extra logic
    /// such as figuring out how to update variable length array of children efficiently).
    ///
    /// It's type-erased because otherwise complex implementation details would be forced to the user
    /// or other compromises would have to be made. I believe that this is the best option with Swift's
    /// current generics landscape.
    public var children: any ViewGraphNodeChildren
    /// A copy of the view itself (from the latest computed body of its parent).
    public var view: NodeView
    /// The backend used to create the view's widget.
    public var backend: Backend

    /// A cancellable handle to the view's state observation.
    private var cancellable: Cancellable?

    /// Creates a node for a given view while also creating the nodes for its children, creating
    /// the view's widget, and starting to observe its state for changes.
    public init(for view: NodeView, backend: Backend) {
        self.view = view
        self.backend = backend

        // First create the view's child nodes and widgets
        children = view.children(backend: backend)

        // Then create the widget for the view itself
        widget = view.asWidget(
            children,
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

    /// Stops observing the view's state.
    deinit {
        cancellable?.cancel()
    }

    /// Replaces the node's view with a new version computed while recomputing the body of its parent
    /// (e.g. when its parent's state updates).
    public func update(with newView: NodeView) {
        var newView = newView
        newView.state = view.state
        view = newView

        update()
    }

    /// Recomputes the view's body, and updates its children and widget accordingly.
    public func update() {
        view.updateChildren(children, backend: backend)
        view.update(widget, children: children, backend: backend)
        backend.show(widget: widget)
    }
}
