extension Scene {
    public func commands(@CommandsBuilder _ commands: () -> Commands) -> some Scene {
        CommandsModifier(content: self, commands: commands())
    }
}

struct CommandsModifier<Content: Scene>: Scene {
    typealias Node = CommandsModifierNode<Content>

    var content: Content
    var commands: Commands

    init(content: Content, commands: Commands) {
        self.content = content
        self.commands = commands
    }
}

final class CommandsModifierNode<Content: Scene>: SceneGraphNode {
    typealias NodeScene = CommandsModifier<Content>

    var commands: Commands
    var contentNode: Content.Node

    init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        self.commands = scene.commands
        self.contentNode = Content.Node(
            from: scene.content,
            backend: backend,
            environment: environment
        )
    }

    func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: EnvironmentValues
    ) -> SceneUpdateResult {
        if let newScene {
            self.commands = newScene.commands
        }

        var result = contentNode.update(
            newScene?.content,
            backend: backend,
            environment: environment
        )
        result.preferences.commands = result.preferences.commands.overlayed(with: commands)
        return result
    }
}
