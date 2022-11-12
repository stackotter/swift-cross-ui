public struct EitherViewChildren<A: View, B: View>: ViewGraphNodeChildren {
    public typealias Content = EitherViewContent<A, B>

    /// Used to avoid the need for a mutating ``update`` method.
    class Storage {
        var viewA: ViewGraphNode<A>?
        var viewB: ViewGraphNode<B>?
        var hasSwitchedCase = true
    }

    let storage: Storage

    public var widgets: [GtkWidget] {
        return [storage.viewA?.widget, storage.viewB?.widget].compactMap { $0 }
    }

    public init(from content: Content) {
        storage = Storage()
        switch content.storage {
            case .a(let a):
                storage.viewA = ViewGraphNode(for: a)
            case .b(let b):
                storage.viewB = ViewGraphNode(for: b)
        }
    }

    public func update(with content: Content) {
        switch content.storage {
            case .a(let a):
                if let viewA = storage.viewA {
                    viewA.update(with: a)
                    storage.hasSwitchedCase = false
                } else {
                    storage.viewA = ViewGraphNode(for: a)
                    storage.viewB = nil
                    storage.hasSwitchedCase = true
                }
            case .b(let b):
                if let viewB = storage.viewB {
                    viewB.update(with: b)
                    storage.hasSwitchedCase = false
                } else {
                    storage.viewB = ViewGraphNode(for: b)
                    storage.viewA = nil
                    storage.hasSwitchedCase = true
                }
        }
    }
}

public struct EitherViewContent<A: View, B: View>: ViewContent {
    public typealias Children = EitherViewChildren<A, B>

    enum Storage {
        case a(A)
        case b(B)
    }

    var storage: Storage

    public init(_ a: A) {
        self.storage = .a(a)
    }

    public init(_ b: B) {
        self.storage = .b(b)
    }
}

public struct _EitherView<A: View, B: View>: View {
    public var body: EitherViewContent<A, B>

    public init(_ a: A) {
        body = EitherViewContent(a)
    }

    public init(_ b: B) {
        body = EitherViewContent(b)
    }

    public func asWidget(_ children: EitherViewChildren<A, B>) -> GtkWidget {
        let box = GtkBox(orientation: .vertical, spacing: 0)
        box.add(children.widgets[0])
        return box
    }

    public func update(_ widget: GtkWidget, children: EitherViewChildren<A, B>) {
        let box = widget as! GtkBox
        if children.storage.hasSwitchedCase {
            box.removeAll()
            box.add(children.widgets[0])
            box.showAll()
        }
    }
}

public struct OptionalViewChildren<V: View>: ViewGraphNodeChildren {
    public typealias Content = OptionalViewContent<V>

    /// Used to avoid the need for a mutating ``update`` method.
    class Storage {
        var view: ViewGraphNode<V>?
        var hasToggled = true
    }

    let storage: Storage

    public var widgets: [GtkWidget] {
        let arr = [storage.view?.widget].compactMap { $0 }
        return arr
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

public struct _OptionalView<V: View>: View {
    public var body: OptionalViewContent<V>

    public init(_ view: V?) {
        body = OptionalViewContent(view)
    }

    public func asWidget(_ children: OptionalViewChildren<V>) -> GtkWidget {
        let box = GtkBox(orientation: .vertical, spacing: 0)
        for widget in children.widgets {
            box.add(widget)
        }
        return box
    }

    public func update(_ widget: GtkWidget, children: OptionalViewChildren<V>) {
        let box = widget as! GtkBox
        if children.storage.hasToggled {
            box.removeAll()
            for widget in children.widgets {
                box.add(widget)
            }
            box.showAll()
        }
    }
}
