import OrderedCollections

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

extension ForEach: TypeSafeView, View where Child: View, Items.Element: Identifiable {
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

        var layoutableChildren: [LayoutSystem.LayoutableChild] = []

        let oldNodes = children.nodes
        let oldMap = children.nodeIdentifierMap
        let oldIdentifiers = children.identifiers
        let identifiersStart = oldIdentifiers.startIndex

        children.nodes = []
        children.nodeIdentifierMap = [:]
        children.identifiers = []

        // Once this is true, every node that existed in the previous update and
        // still exists in the new one is reinserted to ensure that items are
        // rendered in the correct order.
        var requiresOngoingReinsertion = false

        for (i, element) in elements.enumerated() {
            let childContent = child(element)
            let node: AnyViewGraphNode<Child>

            if let oldNode = oldMap[element.id] {
                node = oldNode

                // Checks if there is a preceding item that was not preceding in
                // the previous update. If such an item exists, it means that
                // the order of the collection has changed or that an item was
                // inserted somewhere in the middle, rather than simply appended.
                requiresOngoingReinsertion =
                    requiresOngoingReinsertion
                    || {
                        guard
                            let ownOldIndex = oldIdentifiers.firstIndex(of: element.id)
                        else { return false }

                        let subset = oldIdentifiers[identifiersStart..<ownOldIndex]
                        return !children.identifiers.subtracting(subset).isEmpty
                    }()

                if requiresOngoingReinsertion {
                    removeChild(oldNode.widget.into())
                    addChild(oldNode.widget.into())
                }
            } else {
                // New Items need ongoing reinsertion to get
                // displayed at the correct location.
                requiresOngoingReinsertion = true
                node = AnyViewGraphNode(
                    for: childContent,
                    backend: backend,
                    environment: environment
                )
                addChild(node.widget.into())
            }

            children.nodeIdentifierMap[element.id] = node
            children.identifiers.append(element.id)

            children.nodes.append(node)

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

        for removed in oldMap.filter({
            !children.identifiers.contains($0.key)
        }).values {
            removeChild(removed.widget.into())
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
>: ViewGraphNodeChildren where Items.Index == Int, Items.Element: Identifiable {
    /// The nodes for all current children of the ``ForEach`` view.
    var nodes: [AnyViewGraphNode<Child>] = []

    /// The nodes for all current children of the ``ForEach`` view, queriable by their identifier.
    var nodeIdentifierMap: [Items.Element.ID: AnyViewGraphNode<Child>]

    /// The identifiers of all current children ``ForEach`` view in the order they are displayed.
    /// Can be used for checking if an element was moved or an element was inserted in front of it.
    var identifiers: OrderedSet<Items.Element.ID>

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
        var nodeIdentifierMap = [Items.Element.ID: AnyViewGraphNode<Child>]()
        var identifiers = OrderedSet<Items.Element.ID>()
        var viewNodes = [AnyViewGraphNode<Child>]()

        for (index, element) in view.elements.enumerated() {
            let child = view.child(element)
            let viewGraphNode = {
                let snapshot = index < snapshots?.count ?? 0 ? snapshots?[index] : nil
                return ViewGraphNode(
                    for: child,
                    backend: backend,
                    snapshot: snapshot,
                    environment: environment
                )
            }()

            let anyViewGraphNode = AnyViewGraphNode(viewGraphNode)
            viewNodes.append(anyViewGraphNode)

            identifiers.append(element.id)
            nodeIdentifierMap[element.id] = anyViewGraphNode
        }
        nodes = viewNodes
        self.identifiers = identifiers
        self.nodeIdentifierMap = nodeIdentifierMap
    }
}
