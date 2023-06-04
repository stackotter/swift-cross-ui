import CGtk

/// Built-in icon sizes.
///
/// Icon sizes default to being inherited. Where they cannot be
/// inherited, text size is the default.
///
/// All widgets which use `GtkIconSize` set the normal-icons or
/// large-icons style classes correspondingly, and let themes
/// determine the actual size to be used with the
/// `-gtk-icon-size` CSS property.
public enum IconSize {
    /// Keep the size of the parent element
    case inherit
    /// Size similar to text size
    case normal
    /// Large size, for example in an icon view
    case large

    /// Converts the value to its corresponding Gtk representation.
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
    /// Converts a Gtk value to its corresponding swift representation.
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
