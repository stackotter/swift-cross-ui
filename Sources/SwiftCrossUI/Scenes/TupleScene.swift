public struct TupleScene2<
    Scene0: Scene,
    Scene1: Scene
>: Scene {
    public typealias Node = TupleSceneNode2<
        Scene0,
        Scene1
    >

    var scene0: Scene0
    var scene1: Scene1

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1
    ) {
        self.scene0 = scene0
        self.scene1 = scene1

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
    }
}

public final class TupleSceneNode2<
    Scene0: Scene,
    Scene1: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene2<
        Scene0,
        Scene1
    >

    var node0: Scene0.Node
    var node1: Scene1.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
    }
}
public struct TupleScene3<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene
>: Scene {
    public typealias Node = TupleSceneNode3<
        Scene0,
        Scene1,
        Scene2
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
    }
}

public final class TupleSceneNode3<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene3<
        Scene0,
        Scene1,
        Scene2
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
    }
}
public struct TupleScene4<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene
>: Scene {
    public typealias Node = TupleSceneNode4<
        Scene0,
        Scene1,
        Scene2,
        Scene3
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2
    var scene3: Scene3

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2
        self.scene3 = scene3

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
            .overlayed(with: scene3.commands)
    }
}

public final class TupleSceneNode4<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene4<
        Scene0,
        Scene1,
        Scene2,
        Scene3
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node
    var node3: Scene3.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
        node3 = Scene3.Node(from: scene.scene3, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
        node3.update(newScene?.scene3, backend: backend, environment: environment)
    }
}
public struct TupleScene5<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene
>: Scene {
    public typealias Node = TupleSceneNode5<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2
    var scene3: Scene3
    var scene4: Scene4

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2
        self.scene3 = scene3
        self.scene4 = scene4

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
            .overlayed(with: scene3.commands)
            .overlayed(with: scene4.commands)
    }
}

public final class TupleSceneNode5<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene5<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node
    var node3: Scene3.Node
    var node4: Scene4.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
        node3 = Scene3.Node(from: scene.scene3, backend: backend, environment: environment)
        node4 = Scene4.Node(from: scene.scene4, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
        node3.update(newScene?.scene3, backend: backend, environment: environment)
        node4.update(newScene?.scene4, backend: backend, environment: environment)
    }
}
public struct TupleScene6<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene
>: Scene {
    public typealias Node = TupleSceneNode6<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2
    var scene3: Scene3
    var scene4: Scene4
    var scene5: Scene5

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2
        self.scene3 = scene3
        self.scene4 = scene4
        self.scene5 = scene5

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
            .overlayed(with: scene3.commands)
            .overlayed(with: scene4.commands)
            .overlayed(with: scene5.commands)
    }
}

public final class TupleSceneNode6<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene6<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node
    var node3: Scene3.Node
    var node4: Scene4.Node
    var node5: Scene5.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
        node3 = Scene3.Node(from: scene.scene3, backend: backend, environment: environment)
        node4 = Scene4.Node(from: scene.scene4, backend: backend, environment: environment)
        node5 = Scene5.Node(from: scene.scene5, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
        node3.update(newScene?.scene3, backend: backend, environment: environment)
        node4.update(newScene?.scene4, backend: backend, environment: environment)
        node5.update(newScene?.scene5, backend: backend, environment: environment)
    }
}
public struct TupleScene7<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene
>: Scene {
    public typealias Node = TupleSceneNode7<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2
    var scene3: Scene3
    var scene4: Scene4
    var scene5: Scene5
    var scene6: Scene6

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2
        self.scene3 = scene3
        self.scene4 = scene4
        self.scene5 = scene5
        self.scene6 = scene6

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
            .overlayed(with: scene3.commands)
            .overlayed(with: scene4.commands)
            .overlayed(with: scene5.commands)
            .overlayed(with: scene6.commands)
    }
}

public final class TupleSceneNode7<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene7<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node
    var node3: Scene3.Node
    var node4: Scene4.Node
    var node5: Scene5.Node
    var node6: Scene6.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
        node3 = Scene3.Node(from: scene.scene3, backend: backend, environment: environment)
        node4 = Scene4.Node(from: scene.scene4, backend: backend, environment: environment)
        node5 = Scene5.Node(from: scene.scene5, backend: backend, environment: environment)
        node6 = Scene6.Node(from: scene.scene6, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
        node3.update(newScene?.scene3, backend: backend, environment: environment)
        node4.update(newScene?.scene4, backend: backend, environment: environment)
        node5.update(newScene?.scene5, backend: backend, environment: environment)
        node6.update(newScene?.scene6, backend: backend, environment: environment)
    }
}
public struct TupleScene8<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene,
    Scene7: Scene
>: Scene {
    public typealias Node = TupleSceneNode8<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2
    var scene3: Scene3
    var scene4: Scene4
    var scene5: Scene5
    var scene6: Scene6
    var scene7: Scene7

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6,
        _ scene7: Scene7
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2
        self.scene3 = scene3
        self.scene4 = scene4
        self.scene5 = scene5
        self.scene6 = scene6
        self.scene7 = scene7

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
            .overlayed(with: scene3.commands)
            .overlayed(with: scene4.commands)
            .overlayed(with: scene5.commands)
            .overlayed(with: scene6.commands)
            .overlayed(with: scene7.commands)
    }
}

public final class TupleSceneNode8<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene,
    Scene7: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene8<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node
    var node3: Scene3.Node
    var node4: Scene4.Node
    var node5: Scene5.Node
    var node6: Scene6.Node
    var node7: Scene7.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
        node3 = Scene3.Node(from: scene.scene3, backend: backend, environment: environment)
        node4 = Scene4.Node(from: scene.scene4, backend: backend, environment: environment)
        node5 = Scene5.Node(from: scene.scene5, backend: backend, environment: environment)
        node6 = Scene6.Node(from: scene.scene6, backend: backend, environment: environment)
        node7 = Scene7.Node(from: scene.scene7, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
        node3.update(newScene?.scene3, backend: backend, environment: environment)
        node4.update(newScene?.scene4, backend: backend, environment: environment)
        node5.update(newScene?.scene5, backend: backend, environment: environment)
        node6.update(newScene?.scene6, backend: backend, environment: environment)
        node7.update(newScene?.scene7, backend: backend, environment: environment)
    }
}
public struct TupleScene9<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene,
    Scene7: Scene,
    Scene8: Scene
>: Scene {
    public typealias Node = TupleSceneNode9<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7,
        Scene8
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2
    var scene3: Scene3
    var scene4: Scene4
    var scene5: Scene5
    var scene6: Scene6
    var scene7: Scene7
    var scene8: Scene8

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6,
        _ scene7: Scene7,
        _ scene8: Scene8
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2
        self.scene3 = scene3
        self.scene4 = scene4
        self.scene5 = scene5
        self.scene6 = scene6
        self.scene7 = scene7
        self.scene8 = scene8

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
            .overlayed(with: scene3.commands)
            .overlayed(with: scene4.commands)
            .overlayed(with: scene5.commands)
            .overlayed(with: scene6.commands)
            .overlayed(with: scene7.commands)
            .overlayed(with: scene8.commands)
    }
}

public final class TupleSceneNode9<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene,
    Scene7: Scene,
    Scene8: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene9<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7,
        Scene8
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node
    var node3: Scene3.Node
    var node4: Scene4.Node
    var node5: Scene5.Node
    var node6: Scene6.Node
    var node7: Scene7.Node
    var node8: Scene8.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
        node3 = Scene3.Node(from: scene.scene3, backend: backend, environment: environment)
        node4 = Scene4.Node(from: scene.scene4, backend: backend, environment: environment)
        node5 = Scene5.Node(from: scene.scene5, backend: backend, environment: environment)
        node6 = Scene6.Node(from: scene.scene6, backend: backend, environment: environment)
        node7 = Scene7.Node(from: scene.scene7, backend: backend, environment: environment)
        node8 = Scene8.Node(from: scene.scene8, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
        node3.update(newScene?.scene3, backend: backend, environment: environment)
        node4.update(newScene?.scene4, backend: backend, environment: environment)
        node5.update(newScene?.scene5, backend: backend, environment: environment)
        node6.update(newScene?.scene6, backend: backend, environment: environment)
        node7.update(newScene?.scene7, backend: backend, environment: environment)
        node8.update(newScene?.scene8, backend: backend, environment: environment)
    }
}
public struct TupleScene10<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene,
    Scene7: Scene,
    Scene8: Scene,
    Scene9: Scene
>: Scene {
    public typealias Node = TupleSceneNode10<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7,
        Scene8,
        Scene9
    >

    var scene0: Scene0
    var scene1: Scene1
    var scene2: Scene2
    var scene3: Scene3
    var scene4: Scene4
    var scene5: Scene5
    var scene6: Scene6
    var scene7: Scene7
    var scene8: Scene8
    var scene9: Scene9

    public var commands: Commands

    public init(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6,
        _ scene7: Scene7,
        _ scene8: Scene8,
        _ scene9: Scene9
    ) {
        self.scene0 = scene0
        self.scene1 = scene1
        self.scene2 = scene2
        self.scene3 = scene3
        self.scene4 = scene4
        self.scene5 = scene5
        self.scene6 = scene6
        self.scene7 = scene7
        self.scene8 = scene8
        self.scene9 = scene9

        commands = Commands.empty
            .overlayed(with: scene0.commands)
            .overlayed(with: scene1.commands)
            .overlayed(with: scene2.commands)
            .overlayed(with: scene3.commands)
            .overlayed(with: scene4.commands)
            .overlayed(with: scene5.commands)
            .overlayed(with: scene6.commands)
            .overlayed(with: scene7.commands)
            .overlayed(with: scene8.commands)
            .overlayed(with: scene9.commands)
    }
}

public final class TupleSceneNode10<
    Scene0: Scene,
    Scene1: Scene,
    Scene2: Scene,
    Scene3: Scene,
    Scene4: Scene,
    Scene5: Scene,
    Scene6: Scene,
    Scene7: Scene,
    Scene8: Scene,
    Scene9: Scene
>: SceneGraphNode {
    public typealias NodeScene = TupleScene10<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7,
        Scene8,
        Scene9
    >

    var node0: Scene0.Node
    var node1: Scene1.Node
    var node2: Scene2.Node
    var node3: Scene3.Node
    var node4: Scene4.Node
    var node5: Scene5.Node
    var node6: Scene6.Node
    var node7: Scene7.Node
    var node8: Scene8.Node
    var node9: Scene9.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: Environment
    ) {
        node0 = Scene0.Node(from: scene.scene0, backend: backend, environment: environment)
        node1 = Scene1.Node(from: scene.scene1, backend: backend, environment: environment)
        node2 = Scene2.Node(from: scene.scene2, backend: backend, environment: environment)
        node3 = Scene3.Node(from: scene.scene3, backend: backend, environment: environment)
        node4 = Scene4.Node(from: scene.scene4, backend: backend, environment: environment)
        node5 = Scene5.Node(from: scene.scene5, backend: backend, environment: environment)
        node6 = Scene6.Node(from: scene.scene6, backend: backend, environment: environment)
        node7 = Scene7.Node(from: scene.scene7, backend: backend, environment: environment)
        node8 = Scene8.Node(from: scene.scene8, backend: backend, environment: environment)
        node9 = Scene9.Node(from: scene.scene9, backend: backend, environment: environment)
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: Environment
    ) {
        node0.update(newScene?.scene0, backend: backend, environment: environment)
        node1.update(newScene?.scene1, backend: backend, environment: environment)
        node2.update(newScene?.scene2, backend: backend, environment: environment)
        node3.update(newScene?.scene3, backend: backend, environment: environment)
        node4.update(newScene?.scene4, backend: backend, environment: environment)
        node5.update(newScene?.scene5, backend: backend, environment: environment)
        node6.update(newScene?.scene6, backend: backend, environment: environment)
        node7.update(newScene?.scene7, backend: backend, environment: environment)
        node8.update(newScene?.scene8, backend: backend, environment: environment)
        node9.update(newScene?.scene9, backend: backend, environment: environment)
    }
}
