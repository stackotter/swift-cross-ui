public struct EmptyView: View {
    public typealias NodeChildren = EmptyViewGraphNodeChildren

    public var body: Never {
        return fatalError("Rendered EmptyView")
    }

    public init() {}

    public func asChildren<Backend: AppBackend>(
        backend: Backend
    ) -> any ViewGraphNodeChildren {
        return EmptyViewGraphNodeChildren()
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    ) {}
}

extension Never: View {
    public typealias NodeChildren = EmptyViewGraphNodeChildren

    public var body: Never {
        return fatalError("Rendered Never")
    }

    public init() {
        fatalError("Cannot create never")
    }
}
