import CGtk

/// See also gtk_print_settings_set_paper_width().
public enum Unit {
    /// No units.
    case none
    /// Dimensions in points.
    case points
    /// Dimensions in inches.
    case inch
    /// Dimensions in millimeters
    case mm

    /// Converts the value to its corresponding Gtk representation.
    func toGtkUnit() -> GtkUnit {
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

extension GtkUnit {
    /// Converts a Gtk value to its corresponding swift representation.
    func toUnit() -> Unit {
        switch self {
            case GTK_UNIT_NONE:
                return .none
            case GTK_UNIT_POINTS:
                return .points
            case GTK_UNIT_INCH:
                return .inch
            case GTK_UNIT_MM:
                return .mm
            default:
                fatalError("Unsupported GtkUnit enum value: \(self.rawValue)")
        }
    }
}
