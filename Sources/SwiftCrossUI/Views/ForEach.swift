import OrderedCollections

/// A view that displays a variable amount of children.
public struct ForEach<Items: Collection, ID: Hashable, Child> {
    /// A variable-length collection of elements to display.
    var elements: Items
    /// A method to display the elements as views.
    var child: (Items.Element) -> Child
    /// The path to the property used as Identifier
    var idKeyPath: KeyPath<Items.Element, ID>?
}

extension ForEach: TypeSafeView, View where Child: View {
    typealias Children = ForEachViewChildren<Items, ID, Child>
    public init(
        _ elements: Items,
        id keyPath: KeyPath<Items.Element, ID>,
        @ViewBuilder _ child: @escaping (Items.Element) -> Child
    ) {
        self.elements = elements
        self.child = child
        self.idKeyPath = keyPath
    }

    public var body: EmptyView {
        return EmptyView()
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> Children {
        return Children(
            from: self,
            backend: backend,
            idKeyPath: idKeyPath,
            snapshots: snapshots,
            environment: environment
        )
    }

    func asWidget<Backend: AppBackend>(
        _ children: Children,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createContainer()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
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

        // Use the previous update Method when no keyPath is set on a
        // [Hashable] Collection to optionally keep the old behaviour.
        guard let idKeyPath else {
            return deprecatedUpdate(
                widget,
                children: children,
                proposedSize: proposedSize,
                environment: environment,
                backend: backend,
                dryRun: dryRun
            )
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

        // Forces node recreation when enabled (expensive on large Collections).
        // Use only when idKeyPath yields non-unique values. Prefer Identifiable
        // or guaranteed unique, constant identifiers for optimal performance.
        // Node caching and diffing require unique, stable IDs.
        var ongoingNodeReusingDisabled = false

        // Avoid reallocation
        var inserted = false

        for element in elements {
            let childContent = child(element)
            let node: AnyViewGraphNode<Child>

            // Track duplicates: inserted=false if ID exists.
            // Disables node reuse if any duplicate gets found.
            (inserted, _) = children.identifiers.append(element[keyPath: idKeyPath])
            ongoingNodeReusingDisabled = ongoingNodeReusingDisabled || !inserted

            if !ongoingNodeReusingDisabled {
                if let oldNode = oldMap[element[keyPath: idKeyPath]] {
                    node = oldNode

                    // Detects reordering or mid-collection insertion:
                    // Checks if there is a preceding item that was not
                    // preceding in the previous update.
                    requiresOngoingReinsertion =
                        requiresOngoingReinsertion
                        || {
                            guard
                                let ownOldIndex = oldIdentifiers.firstIndex(
                                    of: element[keyPath: idKeyPath])
                            else { return false }

                            let subset = oldIdentifiers[identifiersStart..<ownOldIndex]
                            return !children.identifiers.subtracting(subset).isEmpty
                        }()

                    // Removes node from its previous position and
                    // re-adds it at the new correct one.
                    if requiresOngoingReinsertion, !children.isFirstUpdate {
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
                    if !children.isFirstUpdate {
                        addChild(node.widget.into())
                    }
                }
                children.nodeIdentifierMap[element[keyPath: idKeyPath]] = node
            } else {
                node = AnyViewGraphNode(
                    for: childContent,
                    backend: backend,
                    environment: environment
                )
            }

            children.nodes.append(node)

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

        if children.isFirstUpdate {
            for nodeToAdd in children.nodes {
                addChild(nodeToAdd.widget.into())
            }
        } else if !ongoingNodeReusingDisabled {
            for removed in oldMap.filter({
                !children.identifiers.contains($0.key)
            }).values {
                removeChild(removed.widget.into())
            }
        } else {
            for nodeToRemove in oldNodes {
                removeChild(nodeToRemove.widget.into())
            }
            for nodeToAdd in children.nodes {
                addChild(nodeToAdd.widget.into())
            }
        }

        children.isFirstUpdate = false

        return LayoutSystem.updateStackLayout(
            container: widget,
            children: layoutableChildren,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
        )
    }

    @MainActor
    func deprecatedUpdate<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
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

        // TODO: The way we're reusing nodes for technically different elements means that if
        //   Child has state of its own then it could get pretty confused thinking that its state
        //   changed whereas it was actually just moved to a new slot in the array. Probably not
        //   a huge issue, but definitely something to keep an eye on.
        var layoutableChildren: [LayoutSystem.LayoutableChild] = []

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

        for element in elements {
            let childContent = child(element)
            let node: AnyViewGraphNode<Child>

            if let oldNode = oldMap[element[keyPath: idKeyPath]] {
                node = oldNode

                // Checks if there is a preceding item that was not preceding in
                // the previous update. If such an item exists, it means that
                // the order of the collection has changed or that an item was
                // inserted somewhere in the middle, rather than simply appended.
                requiresOngoingReinsertion =
                    requiresOngoingReinsertion
                    || {
                        guard
                            let ownOldIndex = oldIdentifiers.firstIndex(
                                of: element[keyPath: idKeyPath])
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
                // displayed at the correct locat ion.
                requiresOngoingReinsertion = true
                node = AnyViewGraphNode(
                    for: childContent,
                    backend: backend,
                    environment: environment
                )
                addChild(node.widget.into())
            }
            let index = elements.index(elements.startIndex, offsetBy: i)
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
            let startIndex = elements.index(elements.startIndex, offsetBy: nodeCount)
            for i in 0..<remainingElementCount {
                let childContent = child(elements[elements.index(startIndex, offsetBy: i)])
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
    ID: Hashable,
    Child: View
>: ViewGraphNodeChildren {
    /// The nodes for all current children of the ``ForEach`` view.
    var nodes: [AnyViewGraphNode<Child>] = []

    /// The nodes for all current children of the ``ForEach`` view, queriable by their identifier.
    var nodeIdentifierMap: [ID: AnyViewGraphNode<Child>]

    /// The identifiers of all current children ``ForEach`` view in the order they are displayed.
    /// Can be used for checking if an element was moved or an element was inserted in front of it.
    var identifiers: OrderedSet<ID>

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
        from view: ForEach<Items, ID, Child>,
        backend: Backend,
        idKeyPath: KeyPath<Items.Element, ID>?,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) {
        guard let idKeyPath else {
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
            identifiers = []
            nodeIdentifierMap = [:]
            return
        }
        var nodeIdentifierMap = [ID: AnyViewGraphNode<Child>]()
        var identifiers = OrderedSet<ID>()
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

            identifiers.append(element[keyPath: idKeyPath])
            nodeIdentifierMap[element[keyPath: idKeyPath]] = anyViewGraphNode
        }
        nodes = viewNodes
        self.identifiers = identifiers
        self.nodeIdentifierMap = nodeIdentifierMap
    }
}

// MARK: - Alternative Initializers
extension ForEach where Items.Element: Hashable, ID == Items.Element {
    /// Creates a view that creates child views on demand based on a collection of data.
    @available(
        *,
        deprecated,
        message: "Use ForEach with id argument on non-Identifiable Elements instead."
    )
    @_disfavoredOverload
    public init(
        items elements: Items,
        _ child: @escaping (Items.Element) -> Child
    ) {
        self.elements = elements
        self.child = child
        self.idKeyPath = nil
    }
}

extension ForEach where Child == [MenuItem], Items.Element: Hashable, ID == Items.Element {
    /// Creates a view that creates child views on demand based on a collection of data.
    @available(
        *,
        deprecated,
        message: "Use ForEach with id argument on non-Identifiable Elements instead."
    )
    @_disfavoredOverload
    public init(
        menuItems elements: Items,
        @MenuItemsBuilder _ child: @escaping (Items.Element) -> [MenuItem]
    ) {
        self.elements = elements
        self.child = child
        self.idKeyPath = nil
    }
}

extension ForEach where Child == [MenuItem] {
    /// Creates a view that creates child views on demand based on a collection of data.
    @_disfavoredOverload
    public init(
        menuItems elements: Items,
        id keyPath: KeyPath<Items.Element, ID>,
        @MenuItemsBuilder _ child: @escaping (Items.Element) -> [MenuItem]
    ) {
        self.elements = elements
        self.child = child
        self.idKeyPath = keyPath
    }
}

extension ForEach where Items == [Int], ID == Items.Element {
    /// Creates a view that creates child views on demand based on a given ClosedRange
    @_disfavoredOverload
    public init(
        _ range: ClosedRange<Int>,
        child: @escaping (Int) -> Child
    ) {
        self.elements = Array(range)
        self.child = child
        self.idKeyPath = \.self
    }

    /// Creates a view that creates child views on demand based on a given Range
    @_disfavoredOverload
    public init(
        _ range: Range<Int>,
        child: @escaping (Int) -> Child
    ) {
        self.elements = Array(range)
        self.child = child
        self.idKeyPath = \.self
    }
}

extension ForEach where Items == [Int] {
    /// Creates a view that creates child views on demand based on a given ClosedRange
    @_disfavoredOverload
    public init(
        _ range: ClosedRange<Int>,
        id keyPath: KeyPath<Items.Element, ID>,
        child: @escaping (Int) -> Child
    ) {
        self.elements = Array(range)
        self.child = child
        self.idKeyPath = keyPath
    }

    /// Creates a view that creates child views on demand based on a given Range
    @_disfavoredOverload
    public init(
        _ range: Range<Int>,
        id keyPath: KeyPath<Items.Element, ID>,
        child: @escaping (Int) -> Child
    ) {
        self.elements = Array(range)
        self.child = child
        self.idKeyPath = keyPath
    }
}

extension ForEach where Items.Element: Identifiable, ID == Items.Element.ID {
    /// Creates a view that creates child views on demand based on a collection of identifiable data.
    public init(
        _ elements: Items,
        child: @escaping (Items.Element) -> Child
    ) {
        self.elements = elements
        self.child = child
        self.idKeyPath = \.id
    }
}
