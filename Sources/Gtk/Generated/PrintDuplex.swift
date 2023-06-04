import CGtk

/// See also gtk_print_settings_set_duplex().
public enum PrintDuplex {
    /// No duplex.
    case simplex
    /// Horizontal duplex.
    case horizontal
    /// Vertical duplex.
    case vertical

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPrintDuplex() -> GtkPrintDuplex {
        switch self {
            case .simplex:
                return GTK_PRINT_DUPLEX_SIMPLEX
            case .horizontal:
                return GTK_PRINT_DUPLEX_HORIZONTAL
            case .vertical:
                return GTK_PRINT_DUPLEX_VERTICAL
        }
    }
}

extension GtkPrintDuplex {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPrintDuplex() -> PrintDuplex {
        switch self {
            case GTK_PRINT_DUPLEX_SIMPLEX:
                return .simplex
            case GTK_PRINT_DUPLEX_HORIZONTAL:
                return .horizontal
            case GTK_PRINT_DUPLEX_VERTICAL:
                return .vertical
            default:
                fatalError("Unsupported GtkPrintDuplex enum value: \(self.rawValue)")
        }
    }
}
