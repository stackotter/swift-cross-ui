/// An item of a ``Menu`` or ``CommandMenu``.
public enum MenuItem: Sendable {
    /// A button.
    case button(Button)
    /// Text.
    case text(Text)
    /// A submenu.
    case submenu(Menu)
}
