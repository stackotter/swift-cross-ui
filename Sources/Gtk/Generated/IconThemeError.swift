import CGtk

/// Error codes for `GtkIconTheme` operations.
public enum IconThemeError {
    /// The icon specified does not exist in the theme
    case notFound
    /// An unspecified error occurred.
    case failed

    /// Converts the value to its corresponding Gtk representation.
    func toGtkIconThemeError() -> GtkIconThemeError {
        switch self {
            case .notFound:
                return GTK_ICON_THEME_NOT_FOUND
            case .failed:
                return GTK_ICON_THEME_FAILED
        }
    }
}

extension GtkIconThemeError {
    /// Converts a Gtk value to its corresponding swift representation.
    func toIconThemeError() -> IconThemeError {
        switch self {
            case GTK_ICON_THEME_NOT_FOUND:
                return .notFound
            case GTK_ICON_THEME_FAILED:
                return .failed
            default:
                fatalError("Unsupported GtkIconThemeError enum value: \(self.rawValue)")
        }
    }
}
