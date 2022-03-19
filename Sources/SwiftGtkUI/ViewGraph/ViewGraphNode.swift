public struct ViewGraphNode<NodeView: View> {
    public var widget: GtkWidget
    public var children: NodeView.Content.Children
    public var view: NodeView

    public init(for view: NodeView) {
        children = NodeView.Content.Children(from: view.body)
        self.view = view
        widget = view.asWidget(children)
    }

    public mutating func update() {
        children.update(with: view.body)
        widget = view.asWidget(children)
    }
}
