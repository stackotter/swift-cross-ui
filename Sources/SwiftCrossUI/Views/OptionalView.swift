public struct OptionalViewChildren<V: View>: ViewGraphNodeChildren {
    /// Used to avoid the need for a mutating ``update`` method.
    class Storage {
        var view: AnyViewGraphNode<V>?
        var hasToggled = true
    }

    let storage: Storage

    public var widgets: [AnyWidget] {
        return [storage.view?.widget].compactMap { $0 }
    }

    public init<Backend: AppBackend>(from view: V?, backend: Backend) {
        storage = Storage()
        if let view = view {
            storage.view = AnyViewGraphNode(for: view, backend: backend)
        }
    }

    public func update<Backend: AppBackend>(with view: V?, backend: Backend) {
        if let view = view {
            if let node = storage.view {
                node.update(with: view)
                storage.hasToggled = false
            } else {
                storage.view = AnyViewGraphNode(for: view, backend: backend)
                storage.hasToggled = true
            }
        } else {
            storage.hasToggled = storage.view != nil
            storage.view = nil
        }
    }
}

public struct OptionalView<V: View>: ContainerView {
    public var body = EmptyView()

    var view: V?

    public init(_ view: V?) {
        self.view = view
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> OptionalViewChildren<V> {
        return OptionalViewChildren(from: view, backend: backend)
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: OptionalViewChildren<V>, backend: Backend
    ) {
        children.update(with: view, backend: backend)
    }

    public func asWidget<Backend: AppBackend>(
        _ children: [Backend.Widget], backend: Backend
    ) -> Backend.Widget {
        return backend.createEitherContainer(initiallyContaining: children.first)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: [Backend.Widget], backend: Backend
    ) {
        backend.setChild(ofEitherContainer: widget, to: children.first)
    }
}
