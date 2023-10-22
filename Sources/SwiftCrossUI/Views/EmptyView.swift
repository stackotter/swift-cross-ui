public struct EmptyView: View {
    public typealias NodeChildren = EmptyViewGraphNodeChildren

    public var body: Never {
        return fatalError("Rendered EmptyView")
    }

    public init() {}
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
