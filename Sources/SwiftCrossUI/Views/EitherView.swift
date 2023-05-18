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

public struct EitherView<A: View, B: View>: View {
    public var body: EitherViewContent<A, B>

    init(_ a: A) {
        body = EitherViewContent(a)
    }

    init(_ b: B) {
        body = EitherViewContent(b)
    }

    public func asWidget(_ children: EitherViewChildren<A, B>) -> GtkSingleChildBox {
        let box = GtkSingleChildBox()
        box.setChild(children.widgets[0])
        return box
    }

    public func update(_ widget: GtkSingleChildBox, children: EitherViewChildren<A, B>) {
        if children.storage.hasSwitchedCase {
            widget.setChild(children.widgets[0])
        }
    }
}
