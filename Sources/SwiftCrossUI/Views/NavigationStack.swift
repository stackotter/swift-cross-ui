/// Type to indicate the root of the NavigationStack. This is internal to prevent root accidentally showing instead
/// of a detail view.
// struct NavigationStackRootPath: Codable {}

// /// A view that displays a root view and enables you to present additional views over the root view.
// ///
// /// Use .navigationDestination(for:destination:) on this view instead of its children unlike Apples SwiftUI API.
// public struct NavigationStack<Detail: View>: TypeSafeView, View {
//     typealias Children = NavigationStackChildren<Detail>

//     public var body = EmptyView()

//     /// A binding to the current navigation path.
//     var path: Binding<NavigationPath>
//     /// The types handled by each destination (in the same order as their
//     /// corresponding views in the stack).
//     var destinationTypes: [any Codable.Type]
//     /// Gets a recursive ``EitherView`` structure which will have a single view
//     /// visible suitable for displaying the given path element (based on its
//     /// type).
//     ///
//     /// It's implemented as a recursive structure because that's the best way to keep this
//     /// typesafe without introducing some crazy generated pseudo-variadic storage types of
//     /// some sort. This way we can easily have unlimited navigation destinations and there's
//     /// just a single simple method for adding a navigation destination.
//     var child: (any Codable) -> Detail?
//     /// The elements of the navigation path. The result can depend on
//     /// ``NavigationStack/destinationTypes`` which determines how the keys are
//     /// decoded if they haven't yet been decoded (this happens if they're loaded
//     /// from disk for persistence).
//     var elements: [any Codable] {
//         let resolvedPath = path.wrappedValue.path(
//             destinationTypes: destinationTypes
//         )
//         return [NavigationStackRootPath()] + resolvedPath
//     }

//     /// Creates a navigation stack with heterogeneous navigation state that you can control.
//     /// - Parameters:
//     ///   - path: A `Binding` to the navigation state for this stack.
//     ///   - root: The view to display when the stack is empty.
//     public init(
//         path: Binding<NavigationPath>,
//         @ViewBuilder _ root: @escaping () -> Detail
//     ) {
//         self.path = path
//         destinationTypes = []
//         child = { element in
//             if element is NavigationStackRootPath {
//                 return root()
//             } else {
//                 return nil
//             }
//         }
//     }

//     /// Associates a destination view with a presented data type for use within a navigation stack.
//     ///
//     /// Add this view modifer to describe the view that the stack displays when presenting a particular
//     /// kind of data. Use a `NavigationLink` to present the data. You can add more than one navigation
//     /// destination modifier to the stack if it needs to present more than one kind of data.
//     /// - Parameters:
//     ///   - data: The type of data that this destination matches.
//     ///   - destination: A view builder that defines a view to display when the stack’s navigation
//     ///     state contains a value of type data. The closure takes one argument, which is the value
//     ///     of the data to present.
//     public func navigationDestination<D: Codable, C: View>(
//         for data: D.Type, @ViewBuilder destination: @escaping (D) -> C
//     ) -> NavigationStack<EitherView<Detail, C>> {
//         // Adds another detail view by adding to the recursive structure of either views created
//         // to display details in a type-safe manner. See NavigationStack.child for details.
//         return NavigationStack<EitherView<Detail, C>>(
//             previous: self,
//             destination: destination
//         )
//     }

//     /// Add a destination for a specific path element (by adding another layer of ``EitherView``).
//     private init<PreviousDetail: View, NewDetail: View, Component: Codable>(
//         previous: NavigationStack<PreviousDetail>,
//         destination: @escaping (Component) -> NewDetail?
//     ) where Detail == EitherView<PreviousDetail, NewDetail> {
//         path = previous.path
//         destinationTypes = previous.destinationTypes + [Component.self]
//         child = {
//             if let previous = previous.child($0) {
//                 // Either root or previously defined destination returned a view
//                 return EitherView(previous)
//             } else if let component = $0 as? Component, let new = destination(component) {
//                 // This destination returned a detail view for the current element
//                 return EitherView(new)
//             } else {
//                 // Possibly a future .navigationDestination will handle this path element
//                 return nil
//             }
//         }
//     }

//     /// Attempts to compute the detail view for the given element (the type of
//     /// the element decides which detail is shown). Crashes if no suitable detail
//     /// view is found.
//     func childOrCrash(for element: any Codable) -> Detail {
//         guard let child = child(element) else {
//             fatalError(
//                 "Failed to find detail view for \"\(element)\", make sure you have called .navigationDestination for this type."
//             )
//         }

//         return child
//     }

//     func children<Backend: AppBackend>(
//         backend: Backend, snapshots: [ViewGraphSnapshotter.NodeSnapshot]?
//     ) -> Children {
//         return NavigationStackChildren(from: self, backend: backend, snapshots: snapshots)
//     }

//     func updateChildren<Backend: AppBackend>(_ children: Children, backend: Backend) {
//         children.update(with: self, backend: backend)
//     }

//     func asWidget<Backend: AppBackend>(
//         _ children: Children, backend: Backend
//     ) -> Backend.Widget {
//         return children.container.into()
//     }

//     func update<Backend: AppBackend>(
//         _ widget: Backend.Widget, children: Children, backend: Backend
//     ) {}
// }

// /// Stores view graph nodes for the detail views of all elements in the current navigation
// /// path (to allow animating back and forth as the navigation path changes).
// ///
// /// The nodes are simply retrieved by calling ``NavigationStack.child`` with every single
// /// element in the navigation path and then type erasing the views in ``AnyViewGraphNode``s.
// ///
// /// Unlike most ``ViewGraphNodeChildren`` implementations (but similarly to ``ForEachChildren``),
// /// this implementation manages the parent ``NavigationStack``'s one-of container as well
// /// to have the complexity in a single type. Most of the complexity is from trying to add
// /// and remove children in just the right way to allow animations to remain fluid even when
// /// the navigation path changes drastically (e.g. 5 elements of the path getting popped at once).
// class NavigationStackChildren<Child: View>: ViewGraphNodeChildren {
//     /// When a view is popped we store it in here to remove from the stack
//     /// the next time views are added. This allows them to animate out.
//     var widgetsQueuedForRemoval: [AnyWidget] = []
//     var nodes: [AnyViewGraphNode<Child>] = []
//     var container: AnyWidget

//     init(container: AnyWidget) {
//         self.container = container
//     }

//     /// This could be set to false for NavigationSplitView in the future
//     let alwaysShowTopView = true

//     var widgets: [AnyWidget] {
//         [container]
//     }

//     var erasedNodes: [ErasedViewGraphNode] {
//         nodes.map(ErasedViewGraphNode.init(wrapping:))
//     }

//     init<Backend: AppBackend>(
//         from view: NavigationStack<Child>,
//         backend: Backend,
//         snapshots: [ViewGraphSnapshotter.NodeSnapshot]?
//     ) {
//         container = AnyWidget(backend.createOneOfContainer())

//         nodes = view.elements
//             .map(view.childOrCrash)
//             .enumerated()
//             .map { (index, view) in
//                 let snapshot = index < snapshots?.count ?? 0 ? snapshots?[index] : nil
//                 return AnyViewGraphNode(for: view, backend: backend, snapshot: snapshot)
//             }

//         for node in nodes {
//             backend.addChild(node.widget.into(), toOneOfContainer: container.into())
//         }
//     }

//     func update<Backend: AppBackend>(with view: NavigationStack<Child>, backend: Backend) {
//         // content.elements is a computed property so only get it once
//         let contentElements = view.elements

//         // Remove queued pages
//         for widget in widgetsQueuedForRemoval {
//             backend.removeChild(widget.into(), fromOneOfContainer: container.into())
//         }
//         widgetsQueuedForRemoval = []

//         // Update pages
//         for (i, node) in nodes.enumerated() {

//             guard i < contentElements.count else {
//                 break
//             }
//             let index = contentElements.startIndex.advanced(by: i)
//             node.update(with: view.childOrCrash(for: contentElements[index]))
//         }

//         let remaining = contentElements.count - nodes.count
//         if remaining > 0 {
//             // Add new pages
//             for i in nodes.count..<(nodes.count + remaining) {
//                 let node = AnyViewGraphNode(
//                     for: view.childOrCrash(for: contentElements[i]),
//                     backend: backend
//                 )
//                 nodes.append(node)
//                 backend.addChild(node.widget.into(), toOneOfContainer: container.into())
//             }
//             // Animate showing the new top page
//             if alwaysShowTopView, let top = nodes.last?.widget {
//                 backend.setVisibleChild(ofOneOfContainer: container.into(), to: top.into())
//             }
//         } else if remaining < 0 {
//             // Animate back to the last page that was not popped
//             if alwaysShowTopView, !contentElements.isEmpty {
//                 let top = nodes[contentElements.count - 1]
//                 backend.setVisibleChild(
//                     ofOneOfContainer: container.into(), to: top.widget.into()
//                 )
//             }

//             // Queue popped pages for removal
//             let unused = -remaining
//             for i in (nodes.count - unused)..<nodes.count {
//                 widgetsQueuedForRemoval.append(nodes[i].widget)
//             }
//             nodes.removeLast(unused)
//         }
//     }

//     private func pageName(for index: Int) -> String {
//         return "NavigationStack page \(index)"
//     }
// }
