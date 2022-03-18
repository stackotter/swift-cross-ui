/// A button view.
public struct Button: View {
    /// The button's label.
    public var label: String
    /// The action to run when the button is clicked.
    public var action: () -> Void
    
    public var body: [View] = []
    
    /// Creates a new button.
    public init(_ label: String, action: @escaping () -> Void = { }) {
        self.label = label
        self.action = action
    }
}

extension Button: _View {
    func build() -> _ViewGraphNode {
        let widget = GtkButton()
        widget.label = label
        widget.clicked = { _ in action() }
        return _ViewGraphNode(widget: widget, children: [])
    }
    
    func update(_ node: inout _ViewGraphNode) {
        let button = node.widget as! GtkButton
        button.label = label
        button.clicked = { _ in action() }
    }
}
