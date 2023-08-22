public struct OptionalViewChildren<V: View>: ViewGraphNodeChildren {
    public typealias Content = OptionalViewContent<V>

    /// Used to avoid the need for a mutating ``update`` method.
    class Storage {
        var view: AnyViewGraphNode<V>?
        var hasToggled = true
    }

    let storage: Storage

    public var widgets: [AnyWidget] {
        return [storage.view?.widget].compactMap { $0 }
    }

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        storage = Storage()
        if let view = content.view {
            storage.view = AnyViewGraphNode(for: view, backend: backend)
        }
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        if let view = content.view {
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

public struct OptionalViewContent<V: View>: ViewContent {
    public typealias Children = OptionalViewChildren<V>

    var view: V?

    public init(_ view: V? = nil) {
        self.view = view
    }
}

public struct OptionalView<V: View>: View {
    public var body: OptionalViewContent<V>

    init(_ view: V?) {
        body = OptionalViewContent(view)
    }

    public func asWidget<Backend: AppBackend>(_ children: OptionalViewChildren<V>, backend: Backend)
        -> Backend.Widget
    {
        return backend.createEitherContainer(initiallyContaining: children.widgets.first?.into())
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: OptionalViewChildren<V>, backend: Backend
    ) {
        if children.storage.hasToggled {
            backend.setChild(ofEitherContainer: widget, to: children.widgets.first?.into())
        }
    }
}
