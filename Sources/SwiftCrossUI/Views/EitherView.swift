public struct EitherViewChildren<A: View, B: View>: ViewGraphNodeChildren {
    class Storage {
        enum EitherNode {
            case a(AnyViewGraphNode<A>)
            case b(AnyViewGraphNode<B>)

            var widget: AnyWidget {
                switch self {
                    case let .a(node):
                        return node.widget
                    case let .b(node):
                        return node.widget
                }
            }
        }

        var eitherNode: EitherNode
        var hasSwitchedCase = true

        init(_ eitherNode: EitherNode) {
            self.eitherNode = eitherNode
        }
    }

    let storage: Storage

    public var widgets: [AnyWidget] {
        return [storage.eitherNode.widget]
    }

    public init<Backend: AppBackend>(from view: EitherView<A, B>, backend: Backend) {
        let eitherNode: Storage.EitherNode
        switch view.storage {
            case .a(let a):
                eitherNode = .a(AnyViewGraphNode(for: a, backend: backend))
            case .b(let b):
                eitherNode = .b(AnyViewGraphNode(for: b, backend: backend))
        }
        storage = Storage(eitherNode)
    }

    public func widget<Backend: AppBackend>(for backend: Backend) -> Backend.Widget {
        return storage.eitherNode.widget.into()
    }

    public func update<Backend: AppBackend>(with view: EitherView<A, B>, backend: Backend) {
        switch view.storage {
            case .a(let a):
                switch storage.eitherNode {
                    case let .a(nodeA):
                        nodeA.update(with: a)
                        storage.hasSwitchedCase = false
                    case .b:
                        storage.eitherNode = .a(AnyViewGraphNode(for: a, backend: backend))
                        storage.hasSwitchedCase = true
                }
            case .b(let b):
                switch storage.eitherNode {
                    case let .b(nodeB):
                        nodeB.update(with: b)
                        storage.hasSwitchedCase = false
                    case .a:
                        storage.eitherNode = .b(AnyViewGraphNode(for: b, backend: backend))
                        storage.hasSwitchedCase = true
                }
        }
    }
}

public struct EitherView<A: View, B: View>: TypeSafeView {
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
        return backend.createEitherContainer(initiallyContaining: children.widget(for: backend))
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: EitherViewChildren<A, B>, backend: Backend
    ) {
        if children.storage.hasSwitchedCase {
            backend.setChild(ofEitherContainer: widget, to: children.widget(for: backend))
        }
    }
}
