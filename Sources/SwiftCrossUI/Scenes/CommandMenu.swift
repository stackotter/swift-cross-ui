public struct CommandMenu: Sendable {
    var name: String
    var content: [MenuItem]

    public init(
        _ name: String,
        @MenuItemsBuilder content: () -> [MenuItem]
    ) {
        self.name = name
        self.content = content()
    }

    init(name: String, content: [MenuItem]) {
        self.name = name
        self.content = content
    }

    /// Resolves the menu to a representation used by backends.
    func resolve() -> ResolvedMenu.Submenu {
        ResolvedMenu.Submenu(
            label: name,
            content: Menu.resolveItems(content)
        )
    }
}
