public struct ViewGraph<Root: App> {
    public typealias RootNode = ViewGraphNode<VStack<Root.Content>>

    public var rootNode: RootNode

    public init(for app: Root) {
        let vStack = VStack(app.body)
        rootNode = ViewGraphNode(for: vStack)
    }
}
