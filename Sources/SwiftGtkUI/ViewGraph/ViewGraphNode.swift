import OpenCombine

public class ViewGraphNode<NodeView: View> {
    public var widget: GtkWidget
    public var children: NodeView.Content.Children
    public var view: NodeView
    public var cancellable: AnyCancellable?

    public init(for view: NodeView) {
        children = NodeView.Content.Children(from: view.body)
        self.view = view
        widget = view.asWidget(children)
        
        cancellable = view.model.objectWillChange.sink { _ in
            self.update()
        }
    }

    public func update(with newView: NodeView) {
        var newView = newView
        newView.model = view.model
        view = newView
        
        update()
    }
    
    public func update() {
        children.update(with: view.body)
        view.update(widget, children: children)
    }
}

