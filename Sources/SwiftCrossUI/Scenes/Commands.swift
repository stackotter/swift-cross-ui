public struct Commands: Sendable {
    public static let empty = Commands(menus: [])

    var menus: [CommandMenu]

    init(menus: [CommandMenu]) {
        self.menus = menus
    }

    public consuming func overlayed(with newCommands: Commands) -> Commands {
        var newMenusByName: [String: Int] = [:]
        for (i, menu) in newCommands.menus.enumerated() {
            newMenusByName[menu.name] = i
        }

        for (i, menu) in menus.enumerated() {
            guard let newMenuIndex = newMenusByName[menu.name] else {
                continue
            }
            menus[i] = CommandMenu(
                name: menu.name,
                content: menu.content + newCommands.menus[newMenuIndex].content
            )
        }

        let existingMenuNames = Set(menus.map(\.name))
        for newMenu in newCommands.menus {
            guard !existingMenuNames.contains(newMenu.name) else {
                continue
            }
            menus.append(newMenu)
        }

        return self
    }

    /// Resolves the menus to a representation used by backends.
    @MainActor
    func resolve() -> [ResolvedMenu.Submenu] {
        menus.map { menu in
            menu.resolve()
        }
    }
}
