
// public struct NavigationStackPath {
//     public var path = [AnyHashable]()

//     public init() {}
// }

public typealias NavigationStackPath = Binding<[AnyHashable]>

/// TODO: doc
public struct NavigationStack<Detail: View>: View {
    public var body: NavigationStackContent<Detail>

    public init(
        path: NavigationStackPath,
        @ViewContentBuilder _ root: @escaping () -> Detail
    ) {
        body = NavigationStackContent(["root"] + path.wrappedValue) { 
            if $0 == "root" as AnyHashable {
                return root()
            } else {
                return nil
            }
        }
    }

    private init<PreviousDetail: ViewContent, NewDetail: View>(
        previous: NavigationStackContent<PreviousDetail>,
        detailPage: @escaping (AnyHashable) -> NewDetail?
    ) where Detail == EitherView<PreviousDetail, NewDetail> {
        body = NavigationStackContent(previous.elements) {
            if let previous = previous.child($0) {
                return EitherView(previous)
            } else if let new = detailPage($0) {
                return EitherView(new)
            } else {
                return nil
            }
        }
    }

    public func asWidget(_ children: NavigationStackChildren<Detail>) -> GtkStack {
        return children.storage.container
    }

    public func navigationDestination<D: Hashable, C: View>(for data: D.Type, @ViewContentBuilder destination: @escaping (D) -> C) -> some View {
        return NavigationStack<EitherViewContent<Detail, C>>(previous: body, detailPage: {
            return ($0 as? D).flatMap(destination)
        })
    }
}

public struct NavigationStackContent<Child: ViewContent>: ViewContent {
    public typealias Children = NavigationStackChildren<Child>

    public var elements: [AnyHashable]
    public var child: (AnyHashable) -> Child?
    
    func childOrCrash(for element: AnyHashable) -> Child {
        assert(child(element) != nil, """
            Failed to find detail view for "\(element)", 
            make sure you have called .navigationDestination for this type.
        """)
        return child(element)!
    }

    ///
    public init(_ elements: [AnyHashable], _ child: @escaping (AnyHashable) -> Child?) {
        self.elements = elements
        self.child = child
    }
}

public struct NavigationStackChildren<Child: ViewContent>: ViewGraphNodeChildren {
    public typealias Content = NavigationStackContent<Child>

    class Storage {
        var nodes: [ViewGraphNode<Child>] = []
        var container = GtkStack(transitionDuration: 300, transitionType: .slideLeftRight)
    }

    let storage = Storage()

    public var widgets: [GtkWidget] {
        return [storage.container]
    }

    public init(from content: Content) {
        storage.nodes = content.elements
            .map(content.childOrCrash)
            .map(ViewGraphNode.init)

        for (node, name) in zip(storage.nodes, content.elements) {
            storage.container.add(node.widget, named: String(describing: name))
        }
    }

    public func update(with content: Content) {
        for (i, node) in storage.nodes.enumerated() {
            guard i < content.elements.count else {
                break
            }
            let index = content.elements.startIndex.advanced(by: i)
            node.update(with: content.childOrCrash(for: content.elements[index]))
        }

        let remaining = content.elements.count - storage.nodes.count
        if remaining > 0 {
            for i in 0..<remaining {
                let index = content.elements.startIndex.advanced(by: i + storage.nodes.count)
                let node = ViewGraphNode(
                    for: content.childOrCrash(for: content.elements[index])
                )
                storage.nodes.append(node)
                storage.container.add(node.widget, named: String(describing: content.elements[index]))
            }
        } else if remaining < 0 {
            let unused = -remaining
            for i in (storage.nodes.count - unused)..<storage.nodes.count {
                storage.container.remove(storage.nodes[i].widget)
            }
            storage.nodes.removeLast(unused)
        }

        if let top = storage.nodes.last?.widget {
            storage.container.setVisible(top)
        }
    }
}

public struct NavigationLink: View {
    public var body: ViewContent1<Button> {
        Button(label, action: {
            path.wrappedValue.append(value)
        })
    }

    private let label: String
    private let value: AnyHashable
    private let path: NavigationStackPath

    /// Creates a new NavigationLink.
    public init(_ label: String, value: AnyHashable, path: NavigationStackPath) {
        self.label = label
        self.value = value
        self.path = path
    }

    // FIXME: Idk why this doesnt compile rn
    public func asWidget(_ children: ViewContent1<Button>.Children) -> Button.Widget {
        return children.view0.widget
    }
}