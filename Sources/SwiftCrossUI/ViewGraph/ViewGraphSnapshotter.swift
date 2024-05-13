import Foundation

public struct ViewGraphSnapshotter: ErasedViewGraphNodeTransformer {
    public struct NodeSnapshot: CustomDebugStringConvertible, Equatable {
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

        public func isValid<V: View>(for viewType: V.Type) -> Bool {
            name(of: V.self) == viewTypeName
        }

        public func restore<V: View>(to view: V) -> V {
            guard isValid(for: V.self) else {
                return view
            }

            switch state {
                case let .encoded(data):
                    return Self.setState(of: view, to: data)
                case .encodingFailure, .none:
                    return view
            }
        }

        private static func setState<V: View>(of view: V, to data: Data) -> V {
            guard
                let decodable = V.State.self as? Codable.Type,
                let state = try? JSONDecoder().decode(decodable, from: data)
            else {
                return view
            }
            var view = view
            view.state = state as! V.State
            return view
        }
    }

    public enum StateSnapshot: CustomDebugStringConvertible, Equatable {
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

    public init() {}

    public func transform<U: View, Backend: AppBackend>(
        node: ViewGraphNode<U, Backend>
    ) -> NodeSnapshot {
        Self.snapshot(of: AnyViewGraphNode(node))
    }

    public static func snapshot<V: View>(of node: AnyViewGraphNode<V>) -> NodeSnapshot {
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
        let snapshotter = ViewGraphSnapshotter()
        let childSnapshots = nodeChildren.map { child in
            child.transform(with: snapshotter)
        }

        return NodeSnapshot(
            viewTypeName: name(of: V.self),
            state: stateSnapshot,
            children: childSnapshots
        )
    }

    public static func name<V: View>(of viewType: V.Type) -> String {
        String(String(describing: V.self).split(separator: "<")[0])
    }

    /// Attempts to match a list of snapshots to a list of views. Uses assumptions about
    /// a few common types of changes which occur when using hot reloading (e.g. adding/removing
    /// single-child modifier views, adding an extra view between two siblings, etc). At
    /// the end of the day, this task is impossible to do in general (by definition), so
    /// this function is expected to just slowly improve over time to suit the majority of
    /// use-cases.
    static func match(
        _ snapshots: [NodeSnapshot],
        to viewTypeNames: [String]
    ) -> [NodeSnapshot?] {
        var sortedSnapshots: [NodeSnapshot?] = Array(repeating: nil, count: viewTypeNames.count)

        var skippedSnapshots: [NodeSnapshot] = []
        var usedIndices: Set<Int> = []
        for snapshot in snapshots {
            var foundView = false
            for (i, viewTypeName) in viewTypeNames.enumerated() where !usedIndices.contains(i) {
                if snapshot.viewTypeName == viewTypeName {
                    sortedSnapshots[i] = snapshot
                    foundView = true
                    usedIndices.insert(i)
                    break
                }
            }
            if !foundView {
                skippedSnapshots.append(snapshot)
            }
        }

        if sortedSnapshots == [nil] {
            let viewTypeName = viewTypeNames[0]
            var children = snapshots
            while children.count == 1 {
                let child = children[0]
                if child.viewTypeName == viewTypeName {
                    return [child]
                } else {
                    children = child.children
                }
            }
            if snapshots.count == 1 {
                return snapshots
            }
        }

        return sortedSnapshots
    }
}
