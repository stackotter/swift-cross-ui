/// A view that displays a variable amount of children.
public struct ForEach<
    Items: Collection,
    Child: View
>: TypeSafeView, View where Items.Index == Int {
    typealias Children = ForEachViewChildren<Items, Child>

    public var body = EmptyView()

    /// A variable-length collection of elements to display.
    var elements: Items
    /// A method to display the elements as views.
    var child: (Items.Element) -> Child

    /// Creates a view that creates child views on demand based on a collection of data.
    public init(
        _ elements: Items,
        @ViewBuilder _ child: @escaping (Items.Element) -> Child
    ) {
        self.elements = elements
        self.child = child
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?
    ) -> ForEachViewChildren<Items, Child> {
        return ForEachViewChildren(from: self, backend: backend, snapshots: snapshots)
    }

    func updateChildren<Backend: AppBackend>(
        _ children: ForEachViewChildren<Items, Child>, backend: Backend
    ) {
        children.update(with: self, backend: backend)
    }

    func asWidget<Backend: AppBackend>(
        _ children: ForEachViewChildren<Items, Child>,
        backend: Backend
    ) -> Backend.Widget {
        return children.container.into()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ForEachViewChildren<Items, Child>,
        backend: Backend
    ) {}
}

/// Stores the child nodes of a ``ForEach`` view.
///
/// Also handles the ``ForEach`` view's widget unlike most ``ViewGraphNodeChildren``
/// implementations. This logic could mostly be moved into ``ForEach`` but it would still
/// be accessing ``ForEachViewChildren/storage`` so it'd just introduce an extra layer of
/// property accesses. It also means that the complexity is in a single type instead of
/// split across two.
///
/// Most of the complexity comes from resizing the list widget and moving around elements
/// when elements are added/removed.
class ForEachViewChildren<
    Items: Collection,
    Child: View
>: ViewGraphNodeChildren where Items.Index == Int {
    /// The nodes for all current children of the ``ForEach`` view.
    var nodes: [AnyViewGraphNode<Child>] = []
    /// The root widget of the ``ForEach`` view. Generally the parent widget isn't managed
    /// by the ``ViewGraphNodeChildren`` implementation, but in this case it makes the most
    /// sense due to how involved updates are.
    var container: AnyWidget

    var widgets: [AnyWidget] {
        return [container]
    }

    var erasedNodes: [ErasedViewGraphNode] {
        nodes.map(ErasedViewGraphNode.init(wrapping:))
    }

    /// Gets a variable length view's children as view graph node children.
    init<Backend: AppBackend>(
        from view: ForEach<Items, Child>,
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?
    ) {
        let container = backend.createLayoutTransparentStack()
        self.container = AnyWidget(container)

        nodes = view.elements
            .map(view.child)
            .enumerated()
            .map { (index, child) in
                let snapshot = index < snapshots?.count ?? 0 ? snapshots?[index] : nil
                return ViewGraphNode(for: child, backend: backend, snapshot: snapshot)
            }
            .map(AnyViewGraphNode.init(_:))

        for node in nodes {
            backend.addChild(node.widget.into(), toLayoutTransparentStack: container)
        }
    }

    /// Updates the variable length list widget with a new instance of the for each view being
    /// represented.
    func update<Backend: AppBackend>(with view: ForEach<Items, Child>, backend: Backend) {
        backend.updateLayoutTransparentStack(container.into())

        // TODO: The way we're reusing nodes for technically different elements means that if
        //   Child has state of its own then it could get pretty confused thinking that its state
        //   changed whereas it was actually just moved to a new slot in the array. Probably not
        //   a huge issue, but definitely something to keep an eye on.
        for (i, node) in nodes.enumerated() {
            guard i < view.elements.count else {
                break
            }
            let index = view.elements.startIndex.advanced(by: i)
            node.update(with: view.child(view.elements[index]))
        }

        let remaining = view.elements.count - nodes.count
        if remaining > 0 {
            let startIndex = view.elements.startIndex.advanced(by: nodes.count)
            for i in 0..<remaining {
                let node = AnyViewGraphNode(
                    for: view.child(view.elements[startIndex.advanced(by: i)]),
                    backend: backend
                )
                nodes.append(node)
                backend.addChild(node.widget.into(), toLayoutTransparentStack: container.into())
            }
        } else if remaining < 0 {
            let unused = -remaining
            for i in (nodes.count - unused)..<nodes.count {
                backend.removeChild(
                    nodes[i].widget.into(),
                    fromLayoutTransparentStack: container.into()
                )
            }
            nodes.removeLast(unused)
        }
    }
}
