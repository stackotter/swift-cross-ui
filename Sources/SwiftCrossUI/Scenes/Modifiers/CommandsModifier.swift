extension Scene {
    public func commands(@CommandsBuilder _ commands: () -> Commands) -> CommandsModifier<Self> {
        CommandsModifier(content: self, newCommands: commands())
    }
}

public struct CommandsModifier<Content: Scene>: Scene {
    public typealias Node = CommandsModifierNode<Content>

    public var content: Content
    public var commands: Commands

    public init(content: Content, newCommands: Commands) {
        self.content = content
        self.commands = content.commands.overlayed(with: newCommands)
    }
}

public final class CommandsModifierNode<Content: Scene>: SceneGraphNode {
    public typealias NodeScene = CommandsModifier<Content>

    var contentNode: Content.Node

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        contentNode = Content.Node(
            from: scene.content,
            backend: backend,
            environment: environment
        )
    }

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        contentNode.update(
            newScene?.content,
            backend: backend,
            environment: environment
        )
    }
}
