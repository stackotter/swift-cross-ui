public struct ForEachViewChildren<
    Items: Collection,
    Child: ViewContent
>: ViewGraphNodeChildren where Items.Index == Int {
    public typealias Content = ForEachViewContent<Items, Child>

    class Storage {
        var nodes: [ViewGraphNode<Child>] = []
        var container = GtkBox(orientation: .vertical, spacing: 0)
    }

    let storage = Storage()

    public var widgets: [GtkWidget] {
        return [storage.container]
    }

    public init(from content: Content) {
        storage.nodes = content.elements
            .map(content.child)
            .map(ViewGraphNode.init)

        for node in storage.nodes {
            storage.container.add(node.widget)
        }
    }

    public func update(with content: Content) {
        if let parent = storage.container.parentWidget as? GtkOrientable {
            storage.container.orientation = parent.orientation
        }

        for (i, node) in storage.nodes.enumerated() {
            guard i < content.elements.count else {
                break
            }
            let index = content.elements.startIndex.advanced(by: i)
            node.update(with: content.child(content.elements[index]))
        }

        let remaining = content.elements.count - storage.nodes.count
        if remaining > 0 {
            for i in storage.nodes.count..<(storage.nodes.count + remaining) {
                let node = ViewGraphNode(
                    for: content.child(content.elements[i])
                )
                storage.nodes.append(node)
                storage.container.add(node.widget)
            }
        } else if remaining < 0 {
            let unused = -remaining
            for i in (storage.nodes.count - unused)..<storage.nodes.count {
                storage.container.remove(storage.nodes[i].widget)
            }
            storage.nodes.removeLast(unused)
        }
    }
}

public struct ForEachViewContent<
    Items: Collection,
    Child: ViewContent
>: ViewContent where Items.Index == Int {
    public typealias Children = ForEachViewChildren<Items, Child>

    public var elements: Items
    public var child: (Items.Element) -> Child

    public init(
        _ elements: Items,
        _ child: @escaping (Items.Element) -> Child
    ) {
        self.elements = elements
        self.child = child
    }
}

/// A view that displays a variable amount of children.
public struct ForEach<
    Items: Collection,
    Child: ViewContent
>: View where Items.Index == Int {
    public var body: ForEachViewContent<Items, Child>

    public init(
        _ elements: Items,
        @ViewContentBuilder _ child: @escaping (Items.Element) -> Child
    ) {
        body = ForEachViewContent(elements, child)
    }

    public func asWidget(
        _ children: ForEachViewChildren<Items, Child>
    ) -> GtkBox {
        return children.storage.container
    }
}
