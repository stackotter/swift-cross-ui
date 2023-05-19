public class ViewGraphNode<NodeView: View> {
    public var widget: NodeView.Widget
    public var children: NodeView.Content.Children
    public var view: NodeView

    private var cancellable: Cancellable?

    public init(for view: NodeView) {
        let content = view.body
        children = NodeView.Content.Children(from: content)
        self.view = view
        widget = view.asWidget(children)
        update(with: content)

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

    public func update(with content: NodeView.Content? = nil) {
        children.update(with: content ?? view.body)
        view.update(widget, children: children)
        widget.show()
    }
}
