public class ViewGraphNode<NodeView: View> {
    public var widget: GtkWidget
    public var children: NodeView.Content.Children
    public var view: NodeView

    private var cancellable: Cancellable?

    public init(for view: NodeView) {
        children = NodeView.Content.Children(from: view.body)
        self.view = view
        widget = view.asWidget(children)

        cancellable = view.state.didChange.observe { [weak self] in
            guard let self = self else { return }
            self.update()
        }
    }

    deinit {
        cancellable?.cancel()
    }

    public func update(with newView: NodeView) {
        var newView = newView
        newView.state = view.state
        view = newView

        update()
    }

    public func update() {
        children.update(with: view.body)
        view.update(widget, children: children)
    }
}
