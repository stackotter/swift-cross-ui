public struct EitherViewChildren<A: View, B: View>: ViewGraphNodeChildren {
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

    public init<Backend: AppBackend>(from view: EitherView<A, B>, backend: Backend) {
        storage = Storage()
        switch view.storage {
            case .a(let a):
                storage.viewA = AnyViewGraphNode(for: a, backend: backend)
            case .b(let b):
                storage.viewB = AnyViewGraphNode(for: b, backend: backend)
        }
    }

    public func update<Backend: AppBackend>(with view: EitherView<A, B>, backend: Backend) {
        switch view.storage {
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

public struct EitherView<A: View, B: View>: ContainerView {
    public typealias NodeChildren = EitherViewChildren<A, B>

    public var body = EmptyView()

    enum Storage {
        case a(A)
        case b(B)
    }

    var storage: Storage

    init(_ a: A) {
        storage = .a(a)
    }

    init(_ b: B) {
        storage = .b(b)
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return EitherViewChildren(from: self, backend: backend)
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.update(with: self, backend: backend)
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
