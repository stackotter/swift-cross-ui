import CGtk3

/// See also gtk_print_settings_set_paper_width().
public enum Unit: GValueRepresentableEnum {
    public typealias GtkEnum = GtkUnit

    /// No units.
    case none
    /// Dimensions in points.
    case points
    /// Dimensions in inches.
    case inch
    /// Dimensions in millimeters
    case mm

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkUnit) {
        switch gtkEnum {
            case GTK_UNIT_NONE:
                self = .none
            case GTK_UNIT_POINTS:
                self = .points
            case GTK_UNIT_INCH:
                self = .inch
            case GTK_UNIT_MM:
                self = .mm
            default:
                fatalError("Unsupported GtkUnit enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkUnit {
        switch self {
            case .none:
                return GTK_UNIT_NONE
            case .points:
                return GTK_UNIT_POINTS
            case .inch:
                return GTK_UNIT_INCH
            case .mm:
                return GTK_UNIT_MM
        }
    }
}
