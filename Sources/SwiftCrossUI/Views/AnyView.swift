import Foundation

/// A view which erases the type of its child. Useful in dynamic
/// use-cases such as hot reloading, but not recommended if there
/// are alternate strongly-typed solutions to your problem since
/// ``AnyView`` has significantly more overhead than strongly
/// typed views.
public struct AnyView: TypeSafeView {
    typealias Children = AnyViewChildren

    public var body = EmptyView()

    var child: any View

    public init(_ child: any View) {
        self.child = child
    }

    func children<Backend: AppBackend>(
        backend: Backend
    ) -> AnyViewChildren {
        return AnyViewChildren(from: self, backend: backend)
    }

    func updateChildren<Backend: AppBackend>(
        _ children: AnyViewChildren, backend: Backend
    ) {
        children.update(with: self, backend: backend)
    }

    func asWidget<Backend: AppBackend>(
        _ children: AnyViewChildren,
        backend: Backend
    ) -> Backend.Widget {
        return children.container.into()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: AnyViewChildren,
        backend: Backend
    ) {}
}

class AnyViewChildren: ViewGraphNodeChildren {
    /// The erased underlying node.
    var node: ErasedViewGraphNode
    /// The single-child container used to allow the child to be swapped
    /// out willy-nilly.
    var container: AnyWidget

    var widgets: [AnyWidget] {
        return [container]
    }

    var erasedNodes: [ErasedViewGraphNode] {
        [node]
    }

    /// Creates the erased child node and wraps the child's widget in a single-child container.
    init<Backend: AppBackend>(from view: AnyView, backend: Backend) {
        node = ErasedViewGraphNode(for: view.child, backend: backend)
        let container = backend.createSingleChildContainer()
        backend.setChild(ofSingleChildContainer: container, to: node.getWidget().into())
        self.container = AnyWidget(container)
    }

    /// Attempts to update the child. If the initial update fails then it means that the child's
    /// concrete type has changed and we must recreate the child node and swap out our current
    /// child widget with the new view's widget.
    func update<Backend: AppBackend>(with view: AnyView, backend: Backend) {
        if !node.updateWithNewView(view.child) {
            node = ErasedViewGraphNode(for: view.child, backend: backend)
            backend.setChild(ofSingleChildContainer: container.into(), to: node.getWidget().into())
        }
    }
}
