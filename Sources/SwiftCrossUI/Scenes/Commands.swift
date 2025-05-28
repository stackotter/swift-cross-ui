public struct Commands: Sendable {
    public static let empty = Commands(menus: [])

    var menus: [CommandMenu]

    init(menus: [CommandMenu]) {
        self.menus = menus
    }

    public func overlayed(with newCommands: Commands) -> Commands {
        var newMenusByName: [String: Int] = [:]
        for (i, menu) in newCommands.menus.enumerated() {
            newMenusByName[menu.name] = i
        }

        var commands = self
        for (i, menu) in menus.enumerated() {
            guard let newMenuIndex = newMenusByName[menu.name] else {
                continue
            }
            commands.menus[i] = CommandMenu(
                name: menu.name,
                content: menu.content + newCommands.menus[newMenuIndex].content
            )
        }

        let existingMenuNames = Set(commands.menus.map(\.name))
        for newMenu in newCommands.menus {
            guard !existingMenuNames.contains(newMenu.name) else {
                continue
            }
            commands.menus.append(newMenu)
        }

        return commands
    }

    /// Resolves the menus to a representation used by backends.
    func resolve() -> [ResolvedMenu.Submenu] {
        menus.map { menu in
            menu.resolve()
        }
    }
}
