/// A view that displays a variable amount of children.
public struct ForEach<
    Items: Collection,
    Child: View
>: TypeSafeView, View where Items.Index == Int {
    typealias Children = ForEachViewChildren<Items, Child>

    public var body = EmptyView()

    public var flexibility: Int {
        300
    }

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
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> ForEachViewChildren<Items, Child> {
        return ForEachViewChildren(
            from: self,
            backend: backend,
            snapshots: snapshots,
            environment: environment
        )
    }

    func asWidget<Backend: AppBackend>(
        _ children: ForEachViewChildren<Items, Child>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createContainer()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ForEachViewChildren<Items, Child>,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        // TODO: The way we're reusing nodes for technically different elements means that if
        //   Child has state of its own then it could get pretty confused thinking that its state
        //   changed whereas it was actually just moved to a new slot in the array. Probably not
        //   a huge issue, but definitely something to keep an eye on.
        var layoutableChildren: [LayoutSystem.LayoutableChild] = []
        for (i, node) in children.nodes.enumerated() {
            guard i < elements.count else {
                break
            }
            let index = elements.startIndex.advanced(by: i)
            let childContent = child(elements[index])
            if children.isFirstUpdate {
                backend.addChild(node.widget.into(), to: widget)
            }
            layoutableChildren.append(
                LayoutSystem.LayoutableChild(
                    flexibility: childContent.flexibility,
                    update: { proposedSize, environment in
                        node.update(
                            with: childContent,
                            proposedSize: proposedSize,
                            environment: environment
                        )
                    }
                )
            )
        }
        children.isFirstUpdate = false

        let nodeCount = children.nodes.count
        let remainingElementCount = elements.count - nodeCount
        if remainingElementCount > 0 {
            let startIndex = elements.startIndex.advanced(by: nodeCount)
            for i in 0..<remainingElementCount {
                let childContent = child(elements[startIndex.advanced(by: i)])
                let node = AnyViewGraphNode(
                    for: childContent,
                    backend: backend,
                    environment: environment
                )
                children.nodes.append(node)
                backend.addChild(node.widget.into(), to: widget)
                layoutableChildren.append(
                    LayoutSystem.LayoutableChild(
                        flexibility: childContent.flexibility,
                        update: { proposedSize, environment in
                            node.update(
                                with: childContent,
                                proposedSize: proposedSize,
                                environment: environment
                            )
                        }
                    )
                )
            }
        } else if remainingElementCount < 0 {
            let unused = -remainingElementCount
            for i in (nodeCount - unused)..<nodeCount {
                backend.removeChild(children.nodes[i].widget.into(), from: widget)
            }
            children.nodes.removeLast(unused)
        }

        return LayoutSystem.updateStackLayout(
            container: widget,
            children: layoutableChildren,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend
        )
    }
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

    var isFirstUpdate = true

    var widgets: [AnyWidget] {
        nodes.map(\.widget)
    }

    var erasedNodes: [ErasedViewGraphNode] {
        nodes.map(ErasedViewGraphNode.init(wrapping:))
    }

    /// Gets a variable length view's children as view graph node children.
    init<Backend: AppBackend>(
        from view: ForEach<Items, Child>,
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) {
        nodes = view.elements
            .map(view.child)
            .enumerated()
            .map { (index, child) in
                let snapshot = index < snapshots?.count ?? 0 ? snapshots?[index] : nil
                return ViewGraphNode(
                    for: child,
                    backend: backend,
                    snapshot: snapshot,
                    environment: environment
                )
            }
            .map(AnyViewGraphNode.init(_:))
    }
}
