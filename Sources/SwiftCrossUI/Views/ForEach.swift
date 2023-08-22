public struct ForEachViewChildren<
    Items: Collection,
    Child: ViewContent
>: ViewGraphNodeChildren where Items.Index == Int {
    public typealias Content = ForEachViewContent<Items, Child>

    class Storage {
        var nodes: [AnyViewGraphNode<Child>] = []
        var container: AnyWidget

        init(container: AnyWidget) {
            self.container = container
        }
    }

    let storage: Storage

    public var widgets: [AnyWidget] {
        return [storage.container]
    }

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        let container = backend.createListView()
        storage = Storage(container: AnyWidget(container))

        storage.nodes = content.elements
            .map(content.child)
            .map { child in
                ViewGraphNode(for: child, backend: backend)
            }
            .map(AnyViewGraphNode.init(_:))

        for node in storage.nodes {
            backend.addChild(node.widget.into(), toListView: container)
        }
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        backend.updateListView(storage.container.into())

        for (i, node) in storage.nodes.enumerated() {
            guard i < content.elements.count else {
                break
            }
            let index = content.elements.startIndex.advanced(by: i)
            node.update(with: content.child(content.elements[index]))
        }

        let remaining = content.elements.count - storage.nodes.count
        if remaining > 0 {
            let startIndex = content.elements.startIndex.advanced(by: storage.nodes.count)
            for i in 0..<remaining {
                let node = AnyViewGraphNode(
                    for: content.child(content.elements[startIndex.advanced(by: i)]),
                    backend: backend
                )
                storage.nodes.append(node)
                backend.addChild(node.widget.into(), toListView: storage.container.into())
            }
        } else if remaining < 0 {
            let unused = -remaining
            for i in (storage.nodes.count - unused)..<storage.nodes.count {
                backend.removeChild(
                    storage.nodes[i].widget.into(),
                    fromListView: storage.container.into()
                )
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

    public func asWidget<Backend: AppBackend>(
        _ children: ForEachViewChildren<Items, Child>,
        backend: Backend
    ) -> Backend.Widget {
        return children.storage.container.into()
    }
}
