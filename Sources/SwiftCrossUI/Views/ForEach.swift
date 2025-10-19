/// A view that displays a variable amount of children.
public struct ForEach<Items: Collection, Child> where Items.Index == Int {
    /// A variable-length collection of elements to display.
    var elements: Items
    /// A method to display the elements as views.
    var child: (Items.Element) -> Child
}

extension ForEach where Child == [MenuItem] {
    /// Creates a view that creates child views on demand based on a collection of data.
    @_disfavoredOverload
    public init(
        _ elements: Items,
        @MenuItemsBuilder _ child: @escaping (Items.Element) -> [MenuItem]
    ) {
        self.elements = elements
        self.child = child
    }
}

extension ForEach where Items == [Int] {
    /// Creates a view that creates child views on demand based on a given ClosedRange
    @_disfavoredOverload
    public init(
        _ range: ClosedRange<Int>,
        child: @escaping (Int) -> Child
    ) {
        self.elements = Array(range)
        self.child = child
    }
    
    /// Creates a view that creates child views on demand based on a given Range
    @_disfavoredOverload
    public init(
        _ range: Range<Int>,
        child: @escaping (Int) -> Child
    ) {
        self.elements = Array(range)
        self.child = child
    }
}

extension ForEach: TypeSafeView, View where Child: View {
    typealias Children = ForEachViewChildren<Items, Child>

    public var body: EmptyView {
        return EmptyView()
    }

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
        environment: EnvironmentValues
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
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        func addChild(_ child: Backend.Widget) {
            if dryRun {
                children.queuedChanges.append(.addChild(AnyWidget(child)))
            } else {
                backend.addChild(child, to: widget)
            }
        }

        func removeChild(_ child: Backend.Widget) {
            if dryRun {
                children.queuedChanges.append(.removeChild(AnyWidget(child)))
            } else {
                backend.removeChild(child, from: widget)
            }
        }

        if !dryRun {
            for change in children.queuedChanges {
                switch change {
                    case .addChild(let child):
                        backend.addChild(child.into(), to: widget)
                    case .removeChild(let child):
                        backend.removeChild(child.into(), from: widget)
                }
            }
            children.queuedChanges = []
        }

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
                addChild(node.widget.into())
            }
            layoutableChildren.append(
                LayoutSystem.LayoutableChild(
                    update: { proposedSize, environment, dryRun in
                        node.update(
                            with: childContent,
                            proposedSize: proposedSize,
                            environment: environment,
                            dryRun: dryRun
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
                addChild(node.widget.into())
                layoutableChildren.append(
                    LayoutSystem.LayoutableChild(
                        update: { proposedSize, environment, dryRun in
                            node.update(
                                with: childContent,
                                proposedSize: proposedSize,
                                environment: environment,
                                dryRun: dryRun
                            )
                        }
                    )
                )
            }
        } else if remainingElementCount < 0 {
            let unused = -remainingElementCount
            for i in (nodeCount - unused)..<nodeCount {
                removeChild(children.nodes[i].widget.into())
            }
            children.nodes.removeLast(unused)
        }

        return LayoutSystem.updateStackLayout(
            container: widget,
            children: layoutableChildren,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
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
    /// Changes queued during `dryRun` updates.
    var queuedChanges: [Change] = []

    enum Change {
        case addChild(AnyWidget)
        case removeChild(AnyWidget)
    }

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
        environment: EnvironmentValues
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
