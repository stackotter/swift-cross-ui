/// A type-erased list of data representing the content of a navigation stack.
public typealias NavigationStackPath = Binding<[AnyHashable]>

/// A view that displays a root view and enables you to present additional views over the root view.
/// 
/// Use .navigationDestination(for:destination:) on this view instead of its children unlike Apples SwiftUI API.
public struct NavigationStack<Detail: ViewContent>: View {
    public var body: NavigationStackContent<Detail>

    /// Creates a navigation stack with heterogeneous navigation state that you can control.
    /// 
    /// - Parameters:
    ///   - path: A `Binding` to the navigation state for this stack.
    ///   - root: The view to display when the stack is empty.
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

    /// Associates a destination view with a presented data type for use within a navigation stack.
    /// 
    /// - Parameters:
    ///   - data: The type of data that this destination matches.
    ///   - destination: A view builder that defines a view to display when the stack’s navigation state contains a value of type data. The closure takes one argument, which is the value of the data to present.
    /// 
    /// Add this view modifer to describe the view that the stack displays when presenting a particular kind of data. Use a `NavigationLink` to present the data.
    /// You can add more than one navigation destination modifier to the stack if it needs to present more than one kind of data.
    public func navigationDestination<D: Hashable, C: View>(for data: D.Type, @ViewContentBuilder destination: @escaping (D) -> C) -> some View {
        return NavigationStack<EitherViewContent<Detail, C>>(previous: body, destination: {
            return ($0 as? D).flatMap(destination)
        })
    }

    public func asWidget(_ children: NavigationStackChildren<Detail>) -> GtkStack {
        return children.storage.container
    }

    /// Add a destination for a specific path element
    private init<PreviousDetail: ViewContent, NewDetail: View>(
        previous: NavigationStackContent<PreviousDetail>,
        destination: @escaping (AnyHashable) -> NewDetail?
    ) where Detail == EitherViewContent<PreviousDetail, NewDetail> {
        body = NavigationStackContent(previous.elements) {
            if let previous = previous.child($0) {
                // Either root or previously defined destination returned a view
                return EitherViewContent(previous)
            } else if let new = destination($0) {
                // This destination returned a detail view for the current element
                return EitherViewContent(new)
            } else {
                // Possibly a comming .navigationDestination will handle this path element
                return nil
            }
        }
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

    internal init(_ elements: [AnyHashable], _ child: @escaping (AnyHashable) -> Child?) {
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
    /// This could be set to false for NavigationSplitView in the future
    let alwaysShowTopView = true

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
        // Update pages
        for (i, node) in storage.nodes.enumerated() {
            guard i < content.elements.count else {
                break
            }
            let index = content.elements.startIndex.advanced(by: i)
            node.update(with: content.childOrCrash(for: content.elements[index]))
        }

        let remaining = content.elements.count - storage.nodes.count
        if remaining > 0 {
            // Add new pages
            for i in 0..<remaining {
                let index = content.elements.startIndex.advanced(by: i + storage.nodes.count)
                let node = ViewGraphNode(
                    for: content.childOrCrash(for: content.elements[index])
                )
                storage.nodes.append(node)
                storage.container.add(node.widget, named: String(describing: content.elements[index]))
            }
            // Animate showing the new top page
            if alwaysShowTopView, let top = storage.nodes.last?.widget {
                storage.container.setVisible(top)
            }
        } else if remaining < 0 {
            // Animate back to the last page that will not be popped
            if alwaysShowTopView, !content.elements.isEmpty {                
                let top = storage.nodes[content.elements.count - 1]
                storage.container.setVisible(top.widget)
            }

            // Remove popped pages
            let unused = -remaining
            for i in (storage.nodes.count - unused)..<storage.nodes.count {
                storage.container.remove(storage.nodes[i].widget)
            }
            storage.nodes.removeLast(unused)
        }
    }
}