public class ViewGraph<Root: App> {
    public typealias RootNode = ViewGraphNode<Root.Content, Root.Backend>

    public var rootNode: RootNode
    private var cancellable: Cancellable?
    private var app: Root

    public init(for app: Root, backend: Root.Backend) {
        rootNode = ViewGraphNode(for: app.body, backend: backend)

        self.app = app

        cancellable = app.state.didChange.observe {
            self.update()
        }
    }

    public func update() {
        rootNode.update(with: app.body)
    }
}
