import CGtk

/// Determines how GTK+ handles the sensitivity of stepper arrows at the end of range widgets.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.SensitivityType.html)
public enum SensitivityType {
    /// The arrow is made insensitive if the thumb is at the end.
    case auto
    /// The arrow is always sensitive.
    case on
    /// The arrow is always insensitive.
    case off

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
