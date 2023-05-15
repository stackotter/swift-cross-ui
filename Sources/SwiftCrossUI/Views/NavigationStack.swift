import Gtk

/// Type to indicate the root of the NavigationStack. This is private to prevent root accidentally showing instead of a detail view.
private struct NavigationStackRootPath: Hashable {}

/// A view that displays a root view and enables you to present additional views over the root view.
///
/// Use .navigationDestination(for:destination:) on this view instead of its children unlike Apples SwiftUI API.
public struct NavigationStack<Detail: ViewContent>: View {
    public var body: NavigationStackContent<Detail>
    private var transitionType: StackTransitionType
    private var transitionDuration: Int

    /// Creates a navigation stack with heterogeneous navigation state that you can control.
    ///
    /// - Parameters:
    ///   - path: A `Binding` to the navigation state for this stack.
    ///   - root: The view to display when the stack is empty.
    public init(
        path: Binding<NavigationPath>,
        @ViewContentBuilder _ root: @escaping () -> Detail
    ) {
        transitionType = .slideLeftRight
        transitionDuration = 300
        body = NavigationStackContent([NavigationStackRootPath()] + path.wrappedValue.path) {
            if $0 is NavigationStackRootPath {
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
    public func navigationDestination<D: Hashable, C: View>(for data: D.Type, @ViewContentBuilder destination: @escaping (D) -> C) -> NavigationStack<EitherViewContent<Detail, C>> {
        return NavigationStack<EitherViewContent<Detail, C>>(previous: self, destination: {
            return ($0 as? D).flatMap(destination)
        })
    }

    /// - Parameters:
    ///   - transition: The type of animation that will be used for transitions between pages in the stack
    ///   - duration: Duration of the transition animation in seconds
    public func navigationTransition(_ transition: StackTransitionType, duration: Double) -> some View {
        var view = self
        view.transitionType = transition
        view.transitionDuration = Int(duration * 1000)
        return view
    }

    public func asWidget(_ children: NavigationStackChildren<Detail>) -> GtkStack {
        let stack = children.storage.container
        stack.transitionType = transitionType
        stack.transitionDuration = transitionDuration
        return stack
    }

    public func update(_ widget: GtkStack, children: Content.Children) {
        widget.transitionType = transitionType
        widget.transitionDuration = transitionDuration
    }

    /// Add a destination for a specific path element
    private init<PreviousDetail: ViewContent, NewDetail: View>(
        previous: NavigationStack<PreviousDetail>,
        destination: @escaping (any Hashable) -> NewDetail?
    ) where Detail == EitherViewContent<PreviousDetail, NewDetail> {
        transitionType = previous.transitionType
        transitionDuration = previous.transitionDuration
        body = NavigationStackContent(previous.body.elements) {
            if let previous = previous.body.child($0) {
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

    public var elements: [any Hashable]
    public var child: (any Hashable) -> Child?

    func childOrCrash(for element: any Hashable) -> Child {
        assert(child(element) != nil, """
            Failed to find detail view for "\(element)",
            make sure you have called .navigationDestination for this type.
        """)
        return child(element)!
    }

    internal init(_ elements: [any Hashable], _ child: @escaping (any Hashable) -> Child?) {
        self.elements = elements
        self.child = child
    }
}

public struct NavigationStackChildren<Child: ViewContent>: ViewGraphNodeChildren {
    public typealias Content = NavigationStackContent<Child>

    class Storage {
        /// When a view is popped we store it in here to remove from the stack
        /// the next time views are added. This allows them to animate out.
        var widgetsQueuedForRemoval: [Widget] = []
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
            // Remove queued pages
            for widget in storage.widgetsQueuedForRemoval {
                storage.container.remove(widget)
            }
            storage.widgetsQueuedForRemoval = []
            // Add new pages
            for i in 0..<remaining {
                let index = content.elements.startIndex.advanced(by: i + storage.nodes.count)
                let node = ViewGraphNode(
                    for: content.childOrCrash(for: content.elements[index])
                )
                storage.nodes.append(node)
                // Shouldn't use element as name here as we never update it. So when we for example go from
                // ["root", "detail1"] to ["root", "detail2"] the name will stay as "detail1".
                storage.container.add(node.widget, named: "NavigationStack page \(index)")
            }
            // Animate showing the new top page
            if alwaysShowTopView, let top = storage.nodes.last?.widget {
                storage.container.setVisible(top)
            }
        } else if remaining < 0 {
            // Animate back to the last page that was not popped
            if alwaysShowTopView, !content.elements.isEmpty {
                let top = storage.nodes[content.elements.count - 1]
                storage.container.setVisible(top.widget)
            }

            // Queue popped pages for removal
            let unused = -remaining
            for i in (storage.nodes.count - unused)..<storage.nodes.count {
                storage.widgetsQueuedForRemoval.append(storage.nodes[i].widget)
            }
            storage.nodes.removeLast(unused)
        }
    }
}