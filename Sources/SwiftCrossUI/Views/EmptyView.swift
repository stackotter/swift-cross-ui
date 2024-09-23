/// A placeholder view used by elementary ``View`` implementations which don't have bodies. Fatally
/// crashes if rendered.
public struct EmptyView: View {
    public var body: Never {
        return fatalError("Rendered EmptyView")
    }

    /// Creates a placeholder view (will crash if used in a ``View`` that doesn't override the default
    /// widget creation code, not intended for regular use).
    public init() {}

    public func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> any ViewGraphNodeChildren {
        return EmptyViewChildren()
    }

    public func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) {}

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        backend.createContainer()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        .empty
    }
}

/// The children of a node with no children.
public struct EmptyViewChildren: ViewGraphNodeChildren {
    public let widgets: [AnyWidget] = []
    public let erasedNodes: [ErasedViewGraphNode] = []

    /// Creates an empty collection of children for a node with no children.
    public init() {}
}

/// Used as the body of ``EmptyView`` to end the chain of view bodies.
extension Never: View {
    public var body: Never {
        return fatalError("Rendered Never")
    }

    public init() {
        fatalError("Cannot create never")
    }
}
