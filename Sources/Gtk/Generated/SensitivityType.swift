import CGtk

/// Determines how GTK handles the sensitivity of various controls,
/// such as combo box buttons.
public enum SensitivityType {
    /// The control is made insensitive if no
    /// action can be triggered
    case auto
    /// The control is always sensitive
    case on
    /// The control is always insensitive
    case off

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSensitivityType() -> GtkSensitivityType {
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

extension GtkSensitivityType {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSensitivityType() -> SensitivityType {
        switch self {
            case GTK_SENSITIVITY_AUTO:
                return .auto
            case GTK_SENSITIVITY_ON:
                return .on
            case GTK_SENSITIVITY_OFF:
                return .off
            default:
                fatalError("Unsupported GtkSensitivityType enum value: \(self.rawValue)")
        }
    }
}
