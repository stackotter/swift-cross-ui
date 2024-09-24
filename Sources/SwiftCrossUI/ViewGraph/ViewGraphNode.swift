import Foundation

/// A view graph node storing a view, its widget, and its children (likely a collection of more nodes).
///
/// This is where updates are initiated when a view's state updates, and where state is persisted
/// even when a view gets recomputed by its parent.
public class ViewGraphNode<NodeView: View, Backend: AppBackend> {
    /// The view's single widget for the entirety of its lifetime in the view graph.
    ///
    public var widget: Backend.Widget {
        _widget!
    }
    /// Only optional because of some initialisation order requirements. Private and wrapped to
    /// hide this inconvenient detail.
    private var _widget: Backend.Widget?
    /// The view's children (usually just contains more view graph nodes, but can handle extra logic
    /// such as figuring out how to update variable length array of children efficiently).
    ///
    /// It's type-erased because otherwise complex implementation details would be forced to the user
    /// or other compromises would have to be made. I believe that this is the best option with Swift's
    /// current generics landscape.
    public var children: any ViewGraphNodeChildren {
        get {
            _children!
        }
        set {
            _children = newValue
        }
    }
    /// Only optional because of some initialisation order requirements. Private and wrapped to
    /// hide this inconvenient detail.
    private var _children: (any ViewGraphNodeChildren)?
    /// A copy of the view itself (from the latest computed body of its parent).
    public var view: NodeView
    /// The backend used to create the view's widget.
    public var backend: Backend

    /// Tracks whether ``cachedSize`` is still valid. Uses a conservative approach so it may
    /// occasionally say that the cached size is invalid even when it's in reality still correct.
    var cachedSizeIsValid: Bool
    /// The most recently computed size for the wrapped view.
    var cachedSize: ViewSize
    /// The most recent size proposed by the parent view. Used when updating the wrapped
    /// view as a result of a state change rather than the parent view updating.
    private var lastProposedSize: SIMD2<Int>

    /// A cancellable handle to the view's state observation.
    private var cancellable: Cancellable?

    /// The environment most recently provided by this node's parent.
    private var parentEnvironment: Environment

    /// Creates a node for a given view while also creating the nodes for its children, creating
    /// the view's widget, and starting to observe its state for changes.
    public init(
        for nodeView: NodeView,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot? = nil,
        environment: Environment
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

        cachedSizeIsValid = false
        cachedSize = .empty
        lastProposedSize = .zero
        parentEnvironment = environment

        let children = view.children(
            backend: backend,
            snapshots: childSnapshots,
            environment: updateEnvironment(environment)
        )
        self.children = children

        // Then create the widget for the view itself
        let widget = view.asWidget(
            children,
            backend: backend
        )
        _widget = widget

        let tag = String(String(describing: NodeView.self).split(separator: "<")[0])
        backend.tag(widget: widget, as: tag)

        // Update the view and its children when state changes (children are always updated first)
        cancellable = view.state.didChange.observe { [weak self] in
            guard let self = self else { return }
            self.backend.runInMainThread {
                self.bottomUpUpdate()
            }
        }
    }

    /// Stops observing the view's state.
    deinit {
        cancellable?.cancel()
    }

    /// Triggers the view to be updated as part of a bottom-up chain of updates (where either the
    /// current view gets updated due to a state change and has potential to trigger its parent to
    /// update as well, or the current view's child has propagated such an update upwards).
    private func bottomUpUpdate() {
        // First we compute what size the view will be after the update. If it will change size,
        // propagate the update to this node's parent instead of updating straight away. The
        // cachedSize is guaranteed to be the size that the view was after the last update.
        // cachedSizeIsValid doesn't apply here because it only applies when claiming that
        // cachedSize is actually what you'd get if you called update right now (which we're
        // explicitly *not* doing).
        let currentSize = cachedSize
        let newSize = self.update(
            proposedSize: lastProposedSize,
            environment: parentEnvironment,
            dryRun: true
        )

        if newSize != currentSize {
            self.cachedSize = newSize
            self.cachedSizeIsValid = true
            parentEnvironment.onResize(newSize)
        } else {
            cachedSize = self.update(
                proposedSize: lastProposedSize,
                environment: parentEnvironment,
                dryRun: false
            )
        }
    }

    private func updateEnvironment(_ environment: Environment) -> Environment {
        environment.with(\.onResize) { [weak self] _ in
            guard let self = self else { return }
            self.bottomUpUpdate()
        }
    }

    /// Recomputes the view's body, and updates its widget accordingly. The view may or may not
    /// propagate the update to its children depending on the nature of the update. If `newView`
    /// is provided (in the case that the parent's body got updated) then it simply replaces the
    /// old view while inheriting the old view's state.
    /// - Parameter dryRun: If `true`, only compute sizing and don't update the underlying widget.
    public func update(
        with newView: NodeView? = nil,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        dryRun: Bool
    ) -> ViewSize {
        if dryRun && cachedSizeIsValid && proposedSize == lastProposedSize {
            return cachedSize
        }

        parentEnvironment = environment
        lastProposedSize = proposedSize

        if let newView {
            var newView = newView
            newView.state = view.state
            view = newView
        }

        cachedSize = view.update(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: updateEnvironment(environment),
            backend: backend,
            dryRun: dryRun
        )
        backend.show(widget: widget)

        // We assume that the view's size won't change between consecutive dry run updates and the
        // following real update because groups of updates following that pattern are assumed to
        // be occurring within a single overarching view update. It may seem weird that we set it
        // to false after real updates, but that's because it may get invalidated between a real
        // update and the next dry-run update.
        cachedSizeIsValid = dryRun

        return cachedSize
    }
}
