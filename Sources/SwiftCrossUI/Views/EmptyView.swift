/// A placeholder view used by elementary ``View`` implementations which don't have bodies. Fatally
/// crashes if rendered.
public struct EmptyView: View {
    public typealias NodeChildren = EmptyViewGraphNodeChildren

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
        return EmptyViewGraphNodeChildren()
    }

    public func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    ) {}

    public func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        backend.createContainer()
    }

    public func update<Backend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int> where Backend: AppBackend {
        .zero
    }
}

/// Used as the body of ``EmptyView`` to end the chain of view bodies.
extension Never: View {
    public typealias NodeChildren = EmptyViewGraphNodeChildren

    public var body: Never {
        return fatalError("Rendered Never")
    }

    public init() {
        fatalError("Cannot create never")
    }
}
