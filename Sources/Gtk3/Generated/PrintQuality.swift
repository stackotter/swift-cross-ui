import CGtk3

/// See also gtk_print_settings_set_quality().
public enum PrintQuality: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPrintQuality

    /// Low quality.
    case low
    /// Normal quality.
    case normal
    /// High quality.
    case high
    /// Draft quality.
    case draft

    public static var type: GType {
        gtk_print_quality_get_type()
    }

    public init(from gtkEnum: GtkPrintQuality) {
        switch gtkEnum {
            case GTK_PRINT_QUALITY_LOW:
                self = .low
            case GTK_PRINT_QUALITY_NORMAL:
                self = .normal
            case GTK_PRINT_QUALITY_HIGH:
                self = .high
            case GTK_PRINT_QUALITY_DRAFT:
                self = .draft
            default:
                fatalError("Unsupported GtkPrintQuality enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPrintQuality {
        switch self {
            case .low:
                return GTK_PRINT_QUALITY_LOW
            case .normal:
                return GTK_PRINT_QUALITY_NORMAL
            case .high:
                return GTK_PRINT_QUALITY_HIGH
            case .draft:
                return GTK_PRINT_QUALITY_DRAFT
        }
    }
}
