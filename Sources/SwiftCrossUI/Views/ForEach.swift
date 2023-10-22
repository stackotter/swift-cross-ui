public struct ForEachViewChildren<
    Items: Collection,
    Child: View
>: ViewGraphNodeChildren where Items.Index == Int {
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

    public init<Backend: AppBackend>(from view: ForEach<Items, Child>, backend: Backend) {
        let container = backend.createListView()
        storage = Storage(container: AnyWidget(container))

        storage.nodes = view.elements
            .map(view.child)
            .map { child in
                ViewGraphNode(for: child, backend: backend)
            }
            .map(AnyViewGraphNode.init(_:))

        for node in storage.nodes {
            backend.addChild(node.widget.into(), toListView: container)
        }
    }

    public func update<Backend: AppBackend>(with view: ForEach<Items, Child>, backend: Backend) {
        backend.updateListView(storage.container.into())

        for (i, node) in storage.nodes.enumerated() {
            guard i < view.elements.count else {
                break
            }
            let index = view.elements.startIndex.advanced(by: i)
            node.update(with: view.child(view.elements[index]))
        }

        let remaining = view.elements.count - storage.nodes.count
        if remaining > 0 {
            let startIndex = view.elements.startIndex.advanced(by: storage.nodes.count)
            for i in 0..<remaining {
                let node = AnyViewGraphNode(
                    for: view.child(view.elements[startIndex.advanced(by: i)]),
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

/// A view that displays a variable amount of children.
public struct ForEach<
    Items: Collection,
    Child: View
>: ContainerView where Items.Index == Int {
    public typealias NodeChildren = ForEachViewChildren<Items, Child>

    public var body = EmptyView()

    public var elements: Items
    public var child: (Items.Element) -> Child

    public init(
        _ elements: Items,
        @ViewBuilder _ child: @escaping (Items.Element) -> Child
    ) {
        self.elements = elements
        self.child = child
    }

    public func asChildren<Backend: AppBackend>(
        backend: Backend
    ) -> ForEachViewChildren<Items, Child> {
        return ForEachViewChildren(from: self, backend: backend)
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: ForEachViewChildren<Items, Child>, backend: Backend
    ) {
        children.update(with: self, backend: backend)
    }

    public func asWidget<Backend: AppBackend>(
        _ children: ForEachViewChildren<Items, Child>,
        backend: Backend
    ) -> Backend.Widget {
        return children.storage.container.into()
    }
}
