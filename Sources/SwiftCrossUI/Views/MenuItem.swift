/// An item of a ``Menu`` or ``CommandMenu``.
public enum MenuItem: Sendable {
    case button(Button)
    case text(Text)
    case toggle(Toggle)
    case submenu(Menu)
}
