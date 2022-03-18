/// A vertically oriented container. Similar to a `VStack` in SwiftUI.
public struct VStack: View {
    public var body: [View]
    
    /// Creates a new VStack.
    public init(@ViewBuilder _ content: () -> [View]) {
        body = content()
    }
}

extension VStack: _View {
    func build() -> _ViewGraphNode {
        let widget = GtkBox(orientation: .vertical, spacing: 8)
        var children: [_ViewGraphNode] = []
        for view in body {
            let node = _ViewGraphNode.build(from: view)
            // Add node to the view
            widget.add(node.widget)
            // Add node to the view graph
            children.append(node)
        }
        return _ViewGraphNode(widget: widget, children: children)
    }
    
    func update(_ node: inout _ViewGraphNode) {
        for (i, view) in body.enumerated() {
            _ViewGraphNode.update(&node.children[i], view: view)
        }
    }
}

extension VStack {
    init(_ body: [View]) {
        self.body = body
    }
}
