extension Scene {
    /// Adds menu commands to this scene.
    ///
    /// The commands will typically be displayed in the system's global menu bar
    /// if it has one, or in individual windows' menu bars otherwise.
    ///
    /// - Parameter commands: The commands to add.
    public func commands(@CommandsBuilder _ commands: () -> Commands) -> some Scene {
        CommandsModifier(content: self, newCommands: commands())
    }
}

struct CommandsModifier<Content: Scene>: Scene {
    typealias Node = CommandsModifierNode<Content>

    var content: Content
    var commands: Commands

    init(content: Content, newCommands: Commands) {
        self.content = content
        self.commands = content.commands.overlayed(with: newCommands)
    }
}

final class CommandsModifierNode<Content: Scene>: SceneGraphNode {
    typealias NodeScene = CommandsModifier<Content>

    var contentNode: Content.Node

    init<Backend: AppBackend>(
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

    func update<Backend: AppBackend>(
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
