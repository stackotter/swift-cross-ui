import Foundation

public struct ErasedViewGraphNode {
    var node: Any
    var updateWithNewView: (Any) -> Bool
    var updateNode: () -> Void
    var getWidget: () -> AnyWidget
    var getState: () -> Data?
    var viewType: any View.Type
    var backendType: any AppBackend.Type

    public init<V: View, Backend: AppBackend>(
        for view: V,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot? = nil
    ) {
        self.init(wrapping: ViewGraphNode(for: view, backend: backend, snapshot: snapshot))
    }

    public init<V: View, Backend: AppBackend>(
        wrapping node: ViewGraphNode<V, Backend>
    ) {
        self.node = node
        backendType = Backend.self
        viewType = V.self
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
    }

    public init<V: View>(wrapping node: AnyViewGraphNode<V>) {
        self.init(wrapping: node, backend: node.getBackend())
    }

    private init<V: View, Backend: AppBackend>(
        wrapping node: AnyViewGraphNode<V>, backend: Backend
    ) {
        self.init(wrapping: node.node as! ViewGraphNode<V, Backend>)
    }

    public func transform<R>(with transformer: any ErasedViewGraphNodeTransformer<R>) -> R {
        func helper<V: View, Backend: AppBackend>(
            viewType: V.Type,
            backendType: Backend.Type
        ) -> R {
            transformer.transform(node: node as! ViewGraphNode<V, Backend>)
        }
        return helper(viewType: viewType, backendType: backendType)
    }
}

public protocol ErasedViewGraphNodeTransformer<Return> {
    associatedtype Return

    func transform<V: View, Backend: AppBackend>(node: ViewGraphNode<V, Backend>) -> Return
}
