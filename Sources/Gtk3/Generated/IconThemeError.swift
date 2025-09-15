import CGtk3

/// Error codes for GtkIconTheme operations.
public enum IconThemeError: GValueRepresentableEnum {
    public typealias GtkEnum = GtkIconThemeError

    /// The icon specified does not exist in the theme
    case notFound
    /// An unspecified error occurred.
    case failed

    public static var type: GType {
        gtk_icon_theme_error_get_type()
    }

    public init(from gtkEnum: GtkIconThemeError) {
        switch gtkEnum {
            case GTK_ICON_THEME_NOT_FOUND:
                self = .notFound
            case GTK_ICON_THEME_FAILED:
                self = .failed
            default:
                fatalError("Unsupported GtkIconThemeError enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkIconThemeError {
        switch self {
            case .notFound:
                return GTK_ICON_THEME_NOT_FOUND
            case .failed:
                return GTK_ICON_THEME_FAILED
        }
    }
}
