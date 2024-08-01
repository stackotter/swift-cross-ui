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
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?
    ) -> AnyViewChildren {
        let snapshot = snapshots?.count == 1 ? snapshots?.first : nil
        return AnyViewChildren(from: self, backend: backend, snapshot: snapshot)
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: AnyViewChildren
    ) -> [LayoutSystem.LayoutableChild] {
        // TODO: Figure out a convention for views like this where ``layoutableChildren`` will
        //   never get used unless something has already gone pretty wrong.
        body.layoutableChildren(backend: backend, children: children)
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
        proposedSize: SIMD2<Int>,
        parentOrientation: Orientation,
        backend: Backend
    ) -> SIMD2<Int> {
        children.update(
            with: self,
            proposedSize: proposedSize,
            parentOrientation: parentOrientation,
            backend: backend
        )
    }
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
    init<Backend: AppBackend>(
        from view: AnyView,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot?
    ) {
        node = ErasedViewGraphNode(for: view.child, backend: backend, snapshot: snapshot)
        let container = backend.createContainer()
        backend.addChild(node.getWidget().into(), to: container)
        backend.setPosition(ofChildAt: 0, in: container, to: .zero)
        self.container = AnyWidget(container)
    }

    /// Attempts to update the child. If the initial update fails then it means that the child's
    /// concrete type has changed and we must recreate the child node and swap out our current
    /// child widget with the new view's widget.
    func update<Backend: AppBackend>(
        with view: AnyView,
        proposedSize: SIMD2<Int>,
        parentOrientation: Orientation,
        backend: Backend
    ) -> SIMD2<Int> {
        var (viewTypesMatched, size) = node.updateWithNewView(
            view.child,
            proposedSize,
            parentOrientation
        )

        if !viewTypesMatched {
            backend.removeChild(node.getWidget().into(), from: container.into())
            node = ErasedViewGraphNode(for: view.child, backend: backend)
            backend.addChild(node.getWidget().into(), to: container.into())
            backend.setPosition(ofChildAt: 0, in: container.into(), to: .zero)

            // We can just assume that the update succeeded because we just created the node
            // a few lines earlier (so it's guaranteed that the view types match).
            let result = node.updateWithNewView(view.child, proposedSize, parentOrientation)
            size = result.size
        }

        backend.setSize(of: container.into(), to: size)
        return size
    }
}
