import CGtk

/// Determines how GTK handles the sensitivity of various controls,
/// such as combo box buttons.
public enum SensitivityType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSensitivityType

    /// The control is made insensitive if no
    /// action can be triggered
    case auto
    /// The control is always sensitive
    case on
    /// The control is always insensitive
    case off

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
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
