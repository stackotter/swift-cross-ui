public struct OptionalViewChildren<V: View>: ViewGraphNodeChildren {
    public typealias Content = OptionalViewContent<V>

    /// Used to avoid the need for a mutating ``update`` method.
    class Storage {
        var view: ViewGraphNode<V>?
        var hasToggled = true
    }

    let storage: Storage

    public var widgets: [GtkWidget] {
        return [storage.view?.widget].compactMap { $0 }
    }

    public init(from content: Content) {
        storage = Storage()
        if let view = content.view {
            storage.view = ViewGraphNode(for: view)
        }
    }

    public func update(with content: Content) {
        if let view = content.view {
            if let node = storage.view {
                node.update(with: view)
                storage.hasToggled = false
            } else {
                storage.view = ViewGraphNode(for: view)
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

    public func asWidget(_ children: OptionalViewChildren<V>) -> GtkSingleChildBox {
        let box = GtkSingleChildBox()
        box.setChild(children.widgets.first)
        return box
    }

    public func update(_ widget: GtkSingleChildBox, children: OptionalViewChildren<V>) {
        if children.storage.hasToggled {
            widget.setChild(children.widgets.first)
        }
    }
}
