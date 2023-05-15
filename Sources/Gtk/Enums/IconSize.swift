import CGtk

/// Built-in stock icon sizes.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.IconSize.html)
public enum IconSize {
    /// Keep the size of the parent element.
    case inherit
    /// Size similar to text size.
    case normal
    /// Large size, for example in an icon view.
    case large

    func toGtkIconSize() -> GtkIconSize {
        switch self {
        case .inherit:
            return GTK_ICON_SIZE_INHERIT
        case .normal:
            return GTK_ICON_SIZE_NORMAL
        case .large:
            return GTK_ICON_SIZE_LARGE
        }
    }
}

extension GtkIconSize {
    func toIconSize() -> IconSize {
        switch self {
        case GTK_ICON_SIZE_INHERIT:
            return .inherit
        case GTK_ICON_SIZE_NORMAL:
            return .normal
        case GTK_ICON_SIZE_LARGE:
            return .large
        default:
            fatalError("Unsupported GtkIconSize enum value: \(self.rawValue)")
        }
    }
}
