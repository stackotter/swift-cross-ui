import Foundation

public struct TupleScene2<S0: Scene, S1: Scene>: Scene {
    public typealias Node = TupleSceneNode2<S0, S1>

    var scene0: S0
    var scene1: S1

    public init(_ scene0: S0, _ scene1: S1) {
        self.scene0 = scene0
        self.scene1 = scene1
    }
}

public final class TupleSceneNode2<S0: Scene, S1: Scene>: SceneGraphNode {
    public typealias NodeScene = TupleScene2<S0, S1>

    var node0: S0.Node
    var node1: S1.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend
    ) {
        node0 = S0.Node(from: scene.scene0, backend: backend)
        node1 = S1.Node(from: scene.scene1, backend: backend)
    }

    public func update<Backend: AppBackend>(_ newScene: NodeScene?, backend: Backend) {
        node0.update(newScene?.scene0, backend: backend)
        node1.update(newScene?.scene1, backend: backend)
    }
}
