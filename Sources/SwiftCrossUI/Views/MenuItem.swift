/// An item of a ``Menu`` or ``CommandMenu``.
public enum MenuItem: Sendable {
    case button(Button, Int? = nil)
    case text(Text, Int? = nil)
    case submenu(Menu, Int? = nil)
}

extension MenuItem: Hashable {
    public static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(
            {
                switch self {
                    case .button(_, let int), .text(_, let int), .submenu(_, let int):
                        return int ?? 0
                }
            }())
    }

    package func addingIDIfNeeded(id: Int) -> Self {
        switch self {
            case .button(let button, let int):
                return .button(button, int ?? id)
            case .text(let text, let int):
                return .text(text, int ?? id)
            case .submenu(let menu, let int):
                return .submenu(menu, int ?? id)
        }
    }
}
