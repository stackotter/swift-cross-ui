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
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?
    ) -> any ViewGraphNodeChildren {
        return EmptyViewGraphNodeChildren()
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    ) {}
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
