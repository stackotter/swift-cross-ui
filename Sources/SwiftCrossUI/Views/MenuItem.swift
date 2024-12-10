/// An item of a ``Menu`` or ``CommandMenu``.
public enum MenuItem {
    case button(Button)
    case text(Text)
    case submenu(Menu)
}
