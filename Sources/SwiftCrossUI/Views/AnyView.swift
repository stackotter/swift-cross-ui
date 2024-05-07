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
        return children.widget.into()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: AnyViewChildren,
        backend: Backend
    ) {}
}

struct ErasedViewGraphNode {
    var node: Any
    var updateWithNewView: (Any) -> Void
    var updateNode: () -> Void
    var getWidget: () -> AnyWidget

    public init<V: View, Backend: AppBackend>(for view: V, backend: Backend) {
        let node = ViewGraphNode(for: view, backend: backend)
        self.node = node
        updateWithNewView = { view in
            let view = view as! V
            node.update(with: view)
        }
        updateNode = node.update
        getWidget = {
            return AnyWidget(node.widget)
        }
    }
}

class AnyViewChildren: ViewGraphNodeChildren {
    /// The erased underlying node.
    var node: ErasedViewGraphNode

    var widget: AnyWidget {
        print(type(of: node.getWidget().widget))
        return node.getWidget()
    }

    var widgets: [AnyWidget] {
        return [widget]
    }

    /// Gets a variable length view's children as view graph node children.
    init<Backend: AppBackend>(from view: AnyView, backend: Backend) {
        node = ErasedViewGraphNode(for: view.child, backend: backend)
    }

    /// Updates the variable length list widget with a new instance of the for each view being
    /// represented.
    func update<Backend: AppBackend>(with view: AnyView, backend: Backend) {
        node.updateWithNewView(view.child)
    }
}
