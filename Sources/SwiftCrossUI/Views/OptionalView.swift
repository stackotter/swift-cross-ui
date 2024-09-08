/// A view used by ``ViewBuilder`` to support non-exhaustive if statements.
public struct OptionalView<V: View>: TypeSafeView, View {
    typealias Children = OptionalViewChildren<V>

    public var body = EmptyView()

    public var flexibility: Int {
        view?.flexibility ?? 0
    }

    var view: V?

    /// Wraps an optional view.
    init(_ view: V?) {
        self.view = view
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> OptionalViewChildren<V> {
        // TODO: This is a conservative implementation, perhaps there are some situations
        //   where we could usefully use the snapshots even if there are too many.
        let snapshot = snapshots?.count == 1 ? snapshots?.first : nil
        return OptionalViewChildren(
            from: view,
            backend: backend,
            snapshot: snapshot,
            environment: environment
        )
    }

    func asWidget<Backend: AppBackend>(
        _ children: OptionalViewChildren<V>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createContainer()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: OptionalViewChildren<V>,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        let hasToggled: Bool
        let size: ViewUpdateResult
        if let view = view {
            if let node = children.node {
                size = node.update(with: view, proposedSize: proposedSize, environment: environment)
                hasToggled = false
            } else {
                let node = AnyViewGraphNode(
                    for: view,
                    backend: backend,
                    environment: environment
                )
                children.node = node
                size = node.update(
                    with: view,
                    proposedSize: proposedSize,
                    environment: environment
                )
                hasToggled = true
            }
        } else {
            hasToggled = children.node != nil
            children.node = nil
            size = .empty
        }

        if hasToggled || children.isFirstUpdate {
            backend.removeAllChildren(of: widget)
            if let node = children.node {
                backend.addChild(node.widget.into(), to: widget)
                backend.setPosition(ofChildAt: 0, in: widget, to: .zero)
            }
            children.isFirstUpdate = false
        }

        backend.setSize(of: widget, to: size.size)

        return size
    }
}

/// Stores a view graph node for the view's child if present. Tracks whether
/// the child has toggled since last time the parent was updated or not.
class OptionalViewChildren<V: View>: ViewGraphNodeChildren {
    /// The view graph node for the view's child if present.
    var node: AnyViewGraphNode<V>?
    /// `true` if the first view update hasn't occurred yet.
    var isFirstUpdate = true

    var widgets: [AnyWidget] {
        return [node?.widget].compactMap { $0 }
    }

    var erasedNodes: [ErasedViewGraphNode] {
        if let node = node {
            [ErasedViewGraphNode(wrapping: node)]
        } else {
            []
        }
    }

    /// Creates storage for an optional view's child if present (which can change at
    /// any time).
    init<Backend: AppBackend>(
        from view: V?,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot?,
        environment: Environment
    ) {
        if let view = view {
            node = AnyViewGraphNode(
                for: view,
                backend: backend,
                snapshot: snapshot,
                environment: environment
            )
        }
    }
}
