import CGtk3

/// Determines how GTK+ handles the sensitivity of stepper arrows
/// at the end of range widgets.
public enum SensitivityType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSensitivityType

    /// The arrow is made insensitive if the
    /// thumb is at the end
    case auto
    /// The arrow is always sensitive
    case on
    /// The arrow is always insensitive
    case off

    public static var type: GType {
        gtk_sensitivity_type_get_type()
    }

    public init(from gtkEnum: GtkSensitivityType) {
        switch gtkEnum {
            case GTK_SENSITIVITY_AUTO:
                self = .auto
            case GTK_SENSITIVITY_ON:
                self = .on
            case GTK_SENSITIVITY_OFF:
                self = .off
            default:
                fatalError("Unsupported GtkSensitivityType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkSensitivityType {
        switch self {
            case .auto:
                return GTK_SENSITIVITY_AUTO
            case .on:
                return GTK_SENSITIVITY_ON
            case .off:
                return GTK_SENSITIVITY_OFF
        }
    }
}
