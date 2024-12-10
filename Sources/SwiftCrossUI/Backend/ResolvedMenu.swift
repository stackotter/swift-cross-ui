/// A generic representation of an application menu, pop-up menu, or context menu.
/// This is what eventually gets passed through to the backend.
///
/// Referred to as 'resolved' because SwiftCrossUI provides some relatively
/// abstract ways to specify menu items, and this is the format that it resolves
/// all menus to eventually.
public struct ResolvedMenu {
    /// The menu's items.
    public var items: [Item]

    /// Memberwise initializer.
    public init(items: [ResolvedMenu.Item]) {
        self.items = items
    }

    /// A menu item.
    public enum Item {
        /// A button. A `nil` action means that the button is disabled.
        case button(_ label: String, _ action: (() -> Void)?)
        /// A named submenu.
        case submenu(Submenu)
    }

    /// A named submenu.
    public struct Submenu {
        /// The label of the submenu's entry in its parent menu.
        public var label: String
        /// The menu displayed when the submenu gets activated.
        public var content: ResolvedMenu

        /// Memberwise initializer.
        public init(label: String, content: ResolvedMenu) {
            self.label = label
            self.content = content
        }
    }
}
