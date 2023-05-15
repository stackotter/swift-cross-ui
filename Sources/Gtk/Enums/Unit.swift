import CGtk

/// See also `gtk_print_settings_set_paper_width()`.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.Unit.html)
public enum Unit {
    /// No units.
    case none
    /// Dimensions in points.
    case points
    /// Dimensions in inches.
    case inches
    /// Dimensions in millimeters.
    case millimeters

    func toGtkUnit() -> GtkUnit {
        switch self {
            case .none:
                return GTK_UNIT_NONE
            case .points:
                return GTK_UNIT_POINTS
            case .inches:
                return GTK_UNIT_INCH
            case .millimeters:
                return GTK_UNIT_MM
        }
    }
}

extension GtkUnit {
    func toUnit() -> Unit {
        switch self {
            case GTK_UNIT_NONE:
                return Unit.none
            case GTK_UNIT_POINTS:
                return .points
            case GTK_UNIT_INCH:
                return .inches
            case GTK_UNIT_MM:
                return .millimeters
            default:
                fatalError("Unsupported GtkUnit enum value: \(self.rawValue)")
        }
    }
}
