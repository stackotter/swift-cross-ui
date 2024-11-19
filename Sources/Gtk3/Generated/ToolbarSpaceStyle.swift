import CGtk3

/// Whether spacers are vertical lines or just blank.
public enum ToolbarSpaceStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkToolbarSpaceStyle

    /// Use blank spacers.
    case empty
    /// Use vertical lines for spacers.
    case line

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkToolbarSpaceStyle) {
        switch gtkEnum {
            case GTK_TOOLBAR_SPACE_EMPTY:
                self = .empty
            case GTK_TOOLBAR_SPACE_LINE:
                self = .line
            default:
                fatalError("Unsupported GtkToolbarSpaceStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkToolbarSpaceStyle {
        switch self {
            case .empty:
                return GTK_TOOLBAR_SPACE_EMPTY
            case .line:
                return GTK_TOOLBAR_SPACE_LINE
        }
    }
}
