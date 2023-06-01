public protocol ViewGraphNodeChildren {
    associatedtype Content: ViewContent where Content.Children == Self

    var widgets: [GtkWidget] { get }

    init(from content: Content)

    func update(with content: Content)
}

public struct EmptyViewGraphNodeChildren: ViewGraphNodeChildren {
    public let widgets: [GtkWidget] = []

    public init(from content: EmptyViewContent) {}

    public func update(with content: EmptyViewContent) {}
}

@available(macOS 99.99.0, *)
public struct ViewGraphNodeChildrenVariadic<each Child: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContentVariadic<repeat each Child>

    public var widgets: [GtkWidget] {
        var widgets: [GtkWidget] = []
        repeat widgets.append((each children.element).widget)
        return widgets
    }

    public var children: (repeat ViewGraphNode<each Child>)

    public init(from content: Content) {
        self.children = (repeat ViewGraphNode(for: each content.views.element))
    }

    public func update(with content: Content) {
        repeat (each children.element).update(with: each content.views.element)
    }
}
