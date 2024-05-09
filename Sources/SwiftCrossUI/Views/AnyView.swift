import Foundation

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

struct ErasedViewGraphNode {
    var node: Any
    var updateWithNewView: (Any) -> Bool
    var updateNode: () -> Void
    var getWidget: () -> AnyWidget
    var getState: () -> Data?
    var setState: (Data) -> Void

    public init<V: View, Backend: AppBackend>(for view: V, backend: Backend) {
        let node = ViewGraphNode(for: view, backend: backend)
        self.node = node
        updateWithNewView = { view in
            guard let view = view as? V else {
                return false
            }
            node.update(with: view)
            return true
        }
        updateNode = node.update
        getWidget = {
            return AnyWidget(node.widget)
        }
        getState = {
            guard let encodable = node.view.state as? any Codable else {
                return nil
            }
            return try? JSONEncoder().encode(encodable)
        }
        setState = { data in
        }
    }
}

class AnyViewChildren: ViewGraphNodeChildren {
    /// The erased underlying node.
    var node: ErasedViewGraphNode

    var container: AnyWidget

    var widgets: [AnyWidget] {
        return [container]
    }

    /// Gets a variable length view's children as view graph node children.
    init<Backend: AppBackend>(from view: AnyView, backend: Backend) {
        node = ErasedViewGraphNode(for: view.child, backend: backend)
        let container = backend.createSingleChildContainer()
        backend.setChild(ofSingleChildContainer: container, to: node.getWidget().into())
        self.container = AnyWidget(container)
    }

    /// Updates the variable length list widget with a new instance of the for each view being
    /// represented.
    func update<Backend: AppBackend>(with view: AnyView, backend: Backend) {
        if !node.updateWithNewView(view.child) {
            var child = view.child
            if let previousState = node.getState() {
                child = Self.setState(of: child, to: previousState)
            }
            node = ErasedViewGraphNode(for: child, backend: backend)
            backend.setChild(ofSingleChildContainer: container.into(), to: node.getWidget().into())
        }
    }

    static func setState<V: View>(of view: V, to data: Data) -> V {
        guard
            let decodable = V.State.self as? Codable.Type,
            let state = try? JSONDecoder().decode(decodable, from: data)
        else {
            return view
        }
        var view = view
        view.state = state as! V.State
        return view
    }
}
