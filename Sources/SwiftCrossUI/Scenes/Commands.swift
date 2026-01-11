/// A set of menus to be displayed in a menu bar.
public struct Commands: Sendable {
    /// Represents an empty menu bar.
    public static let empty = Commands(menus: [])

    var menus: [CommandMenu]

    init(menus: [CommandMenu]) {
        self.menus = menus
    }

    /// Overlays `newCommands` onto `self`.
    ///
    /// If top-level menus in `newCommands` and `self` have conflicting names,
    /// the ones in `self` win out.
    ///
    /// - Parameter newCommands: The commands to overlay.
    /// - Returns: The overlayed commands.
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
    @MainActor
    func resolve() -> [ResolvedMenu.Submenu] {
        menus.map { menu in
            menu.resolve()
        }
    }
}
