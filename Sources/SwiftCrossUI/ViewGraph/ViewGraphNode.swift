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
    public init(
        for nodeView: NodeView,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot? = nil
    ) {
        self.backend = backend

        // Restore node snapshot if present.
        self.view = snapshot?.restore(to: nodeView) ?? nodeView

        #if DEBUG
            var mirror: Mirror? = Mirror(reflecting: self.view.state)
            while let aClass = mirror {
                for (label, property) in aClass.children {
                    guard
                        property is ObservedMarkerProtocol,
                        let property = property as? Observable
                    else {
                        continue
                    }

                    property.didChange.tag(with: "(\(label ?? "_"): Observed<_>)")
                }
                mirror = aClass.superclassMirror
            }
        #endif

        // First create the view's child nodes and widgets
        let childSnapshots =
            snapshot?.isValid(for: NodeView.self) == true
            ? snapshot?.children : snapshot.map { [$0] }
        children = view.children(backend: backend, snapshots: childSnapshots)

        // Then create the widget for the view itself
        widget = view.asWidget(
            children,
            backend: backend
        )

        // Update the view and its children when state changes (children are always updated first)
        cancellable = view.state.didChange.observe { [weak self] in
            guard let self = self else { return }
            _ = self.update(proposedSize: SIMD2(200, 200), parentOrientation: .vertical)
        }
    }

    /// Stops observing the view's state.
    deinit {
        cancellable?.cancel()
    }

    /// Replaces the node's view with a new version computed while recomputing the body of its parent
    /// (e.g. when its parent's state updates).
    public func update(
        with newView: NodeView,
        proposedSize: SIMD2<Int>,
        parentOrientation: Orientation
    ) -> SIMD2<Int> {
        var newView = newView
        newView.state = view.state
        view = newView

        return update(proposedSize: proposedSize, parentOrientation: parentOrientation)
    }

    /// Recomputes the view's body, and updates its widget accordingly. The view may or may not
    /// propagate the update to its children depending on the nature of the update.
    public func update(
        proposedSize: SIMD2<Int>,
        parentOrientation: Orientation
    ) -> SIMD2<Int> {
        let size = view.update(
            widget,
            children: children,
            proposedSize: proposedSize,
            parentOrientation: parentOrientation,
            backend: backend
        )
        backend.show(widget: widget)
        return size
    }
}

// VariadicViewN.updateChildren has to be refactored into a function that returns
// the children in the format required by `LayoutSystem.updateStackLayout`.
// (same goes for all other views with custom `updateChildren` functions).
//
// Then ViewGraphNode.update (both versions) have to take proposedSize and
// parentOrientation so that they can correctly update their wrapped views.
//
// Then VStack should be able to work at the very minimum? Might help to just
// comment all views other than VStack, VariadicViewN, and Text until the
// details are all figured out.
