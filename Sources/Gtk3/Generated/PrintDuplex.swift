import CGtk3

/// See also gtk_print_settings_set_duplex().
public enum PrintDuplex: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPrintDuplex

    /// No duplex.
    case simplex
    /// Horizontal duplex.
    case horizontal
    /// Vertical duplex.
    case vertical

    public static var type: GType {
        gtk_print_duplex_get_type()
    }

    public init(from gtkEnum: GtkPrintDuplex) {
        switch gtkEnum {
            case GTK_PRINT_DUPLEX_SIMPLEX:
                self = .simplex
            case GTK_PRINT_DUPLEX_HORIZONTAL:
                self = .horizontal
            case GTK_PRINT_DUPLEX_VERTICAL:
                self = .vertical
            default:
                fatalError("Unsupported GtkPrintDuplex enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPrintDuplex {
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
