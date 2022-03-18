/// A text view.
public struct Text: View {
    /// The text view's content.
    public var string: String
    
    public var body: [View] = []
    
    /// Creates a new text view with the given content.
    public init(_ string: String) {
        self.string = string
    }
}

extension Text: _View {
    func build() -> _ViewGraphNode {
        let widget = GtkLabel(text: string)
        return _ViewGraphNode(widget: widget, children: [])
    }
    
    func update(_ node: inout _ViewGraphNode) {
        let widget = node.widget as! GtkLabel
        widget.text = string
    }
}
