public struct EitherViewChildren<A: View, B: View>: ViewGraphNodeChildren {
    public typealias Content = EitherViewContent<A, B>

    /// Used to avoid the need for a mutating ``update`` method.
    class Storage {
        var viewA: AnyViewGraphNode<A>?
        var viewB: AnyViewGraphNode<B>?
        var hasSwitchedCase = true
    }

    let storage: Storage

    public var widgets: [AnyWidget] {
        return [storage.viewA?.widget, storage.viewB?.widget].compactMap { $0 }
    }

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        storage = Storage()
        switch content.storage {
            case .a(let a):
                storage.viewA = AnyViewGraphNode(for: a, backend: backend)
            case .b(let b):
                storage.viewB = AnyViewGraphNode(for: b, backend: backend)
        }
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        switch content.storage {
            case .a(let a):
                if let viewA = storage.viewA {
                    viewA.update(with: a)
                    storage.hasSwitchedCase = false
                } else {
                    storage.viewA = AnyViewGraphNode(for: a, backend: backend)
                    storage.viewB = nil
                    storage.hasSwitchedCase = true
                }
            case .b(let b):
                if let viewB = storage.viewB {
                    viewB.update(with: b)
                    storage.hasSwitchedCase = false
                } else {
                    storage.viewB = AnyViewGraphNode(for: b, backend: backend)
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

    public func asWidget<Backend: AppBackend>(
        _ children: EitherViewChildren<A, B>, backend: Backend
    ) -> Backend.Widget {
        precondition(children.widgets.count == 1)
        return backend.createEitherContainer(initiallyContaining: children.widgets[0].into())
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: EitherViewChildren<A, B>, backend: Backend
    ) {
        precondition(children.widgets.count == 1)
        if children.storage.hasSwitchedCase {
            backend.setChild(ofEitherContainer: widget, to: children.widgets[0].into())
        }
    }
}
