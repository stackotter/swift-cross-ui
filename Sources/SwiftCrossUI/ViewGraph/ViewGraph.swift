import Foundation

/// The root of the view graph which shadows a root view's structure with extra metadata,
/// cross-update state persistence, and behind the scenes backend widget handling.
///
/// This is where state updates are propagated through the view hierarchy, and also where view
/// bodies get recomputed. The root node is type-erased because otherwise the selected backend
/// would have to get propagated through the entire scene graph which would leak it into
/// ``Scene`` implementations (exposing users to unnecessary internal details).
public class ViewGraph<Root: View> {
    /// The view graph's
    public typealias RootNode = AnyViewGraphNode<Root>

    /// The root node storing the node for the root view's body.
    public var rootNode: RootNode
    /// A cancellable handle to observation of the view's state.
    private var cancellable: Cancellable?
    /// The root view being managed by this view graph.
    private var view: Root

    /// Creates a view graph for a root view with a specific backend.
    public init<Backend: AppBackend>(for view: Root, backend: Backend) {
        rootNode = AnyViewGraphNode(for: view, backend: backend)

        self.view = view

        cancellable = view.state.didChange.observe {
            self.update()
        }
    }

    /// Recomputes the entire UI (e.g. due to the root view's state updating).
    /// If the update is due to the parent scene getting updated then the view]
    /// is recomputed and passed as `newView`.
    public func update(_ newView: Root? = nil) {
        rootNode.update(with: newView ?? view)
    }

    public func snapshot() -> Snapshotter.NodeSnapshot {
        Snapshotter.snapshot(of: rootNode)
    }
}

public struct Snapshotter: ErasedViewGraphNodeTransformer {
    public struct NodeSnapshot: CustomDebugStringConvertible {
        var viewTypeName: String
        var state: StateSnapshot?
        var children: [NodeSnapshot]

        public var debugDescription: String {
            var description = "\(viewTypeName)"
            if let state = state {
                description += "\n| state: \(state.debugDescription)"
            }

            if !children.isEmpty {
                var childDescriptions: [String] = []
                for (i, child) in children.enumerated() {
                    let linePrefix: String
                    if i == children.count - 1 {
                        linePrefix = "    "
                    } else {
                        linePrefix = "|   "
                    }
                    let childDescription = child.debugDescription
                        .split(separator: "\n")
                        .joined(separator: "\n\(linePrefix)")
                    childDescriptions.append("|-> \(childDescription)")
                }
                description += "\n"
                description += childDescriptions.joined(separator: "\n")
            }

            return description
        }
    }

    public enum StateSnapshot: CustomDebugStringConvertible {
        case encodingFailure
        case encoded(Data)

        public var debugDescription: String {
            switch self {
                case .encodingFailure:
                    return "failedToEncode"
                case let .encoded(data):
                    return String(data: data, encoding: .utf8) ?? "invalidUTF8"
            }
        }
    }

    public func transform<U: View, Backend: AppBackend>(
        node: ViewGraphNode<U, Backend>
    ) -> NodeSnapshot {
        Self.snapshot(of: AnyViewGraphNode(node))
    }

    static func snapshot<V: View>(of node: AnyViewGraphNode<V>) -> NodeSnapshot {
        let stateSnapshot: StateSnapshot?
        if let state = node.getView().state as? Codable {
            if let encodedState = try? JSONEncoder().encode(state) {
                stateSnapshot = .encoded(encodedState)
            } else {
                stateSnapshot = .encodingFailure
            }
        } else {
            stateSnapshot = nil
        }

        let nodeChildren = node.getChildren().erasedNodes
        let snapshotter = Snapshotter()
        let childSnapshots = nodeChildren.map { child in
            child.transform(with: snapshotter)
        }

        return NodeSnapshot(
            viewTypeName: String(String(describing: V.self).split(separator: "<")[0]),
            state: stateSnapshot,
            children: childSnapshots
        )
    }
}
