/// A view used by ``ViewBuilder`` to support if/else conditional statements.
public struct EitherView<A: View, B: View>: TypeSafeView, View {
    typealias NodeChildren = EitherViewChildren<A, B>

    public var body = EmptyView()

    /// Stores one of two possible view types.
    enum Storage {
        case a(A)
        case b(B)
    }

    var storage: Storage

    /// Creates an either view with its first case visible initially.
    init(_ a: A) {
        storage = .a(a)
    }

    /// Creates an either view with its second case visible initially.
    init(_ b: B) {
        storage = .b(b)
    }

    func children<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return EitherViewChildren(from: self, backend: backend)
    }

    func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.update(with: self, backend: backend)
    }

    func asWidget<Backend: AppBackend>(
        _ children: EitherViewChildren<A, B>, backend: Backend
    ) -> Backend.Widget {
        return backend.createSingleChildContainer()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: EitherViewChildren<A, B>, backend: Backend
    ) {
        if children.hasSwitchedCase || children.isFirstUpdate {
            backend.setChild(ofSingleChildContainer: widget, to: children.widget(for: backend))
        }
        children.isFirstUpdate = false
    }
}

/// Uses an `enum` to store a view graph node for one of two possible child view types.
class EitherViewChildren<A: View, B: View>: ViewGraphNodeChildren {
    /// A view graph node that wraps one of two possible child view types.
    enum EitherNode {
        case a(AnyViewGraphNode<A>)
        case b(AnyViewGraphNode<B>)

        /// The widget corresponding to the currently displayed child view.
        var widget: AnyWidget {
            switch self {
                case let .a(node):
                    return node.widget
                case let .b(node):
                    return node.widget
            }
        }
    }

    /// The view graph node for the currently displayed child.
    var node: EitherNode
    /// Whether the view has switched children since the last time the parent widget was
    /// updated.
    var hasSwitchedCase = true
    /// `true` if the first view update hasn't occurred yet.
    var isFirstUpdate = true

    var widgets: [AnyWidget] {
        return [node.widget]
    }

    /// Creates storage for an either view's current child (which can change at any time).
    init<Backend: AppBackend>(from view: EitherView<A, B>, backend: Backend) {
        switch view.storage {
            case .a(let a):
                node = .a(AnyViewGraphNode(for: a, backend: backend))
            case .b(let b):
                node = .b(AnyViewGraphNode(for: b, backend: backend))
        }
    }

    func widget<Backend: AppBackend>(for backend: Backend) -> Backend.Widget {
        return node.widget.into()
    }

    func update<Backend: AppBackend>(with view: EitherView<A, B>, backend: Backend) {
        switch view.storage {
            case .a(let a):
                switch node {
                    case let .a(nodeA):
                        nodeA.update(with: a)
                        hasSwitchedCase = false
                    case .b:
                        node = .a(AnyViewGraphNode(for: a, backend: backend))
                        hasSwitchedCase = true
                }
            case .b(let b):
                switch node {
                    case let .b(nodeB):
                        nodeB.update(with: b)
                        hasSwitchedCase = false
                    case .a:
                        node = .b(AnyViewGraphNode(for: b, backend: backend))
                        hasSwitchedCase = true
                }
        }
    }
}
