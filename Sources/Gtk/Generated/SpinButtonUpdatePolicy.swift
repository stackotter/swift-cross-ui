import CGtk

/// Determines whether the spin button displays values outside the adjustment
/// bounds.
///
/// See [method@Gtk.SpinButton.set_update_policy].
public enum SpinButtonUpdatePolicy {
    /// When refreshing your `GtkSpinButton`, the value is
    /// always displayed
    case always
    /// When refreshing your `GtkSpinButton`, the value is
    /// only displayed if it is valid within the bounds of the spin button's
    /// adjustment
    case ifValid

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSpinButtonUpdatePolicy() -> GtkSpinButtonUpdatePolicy {
        switch self {
            case .always:
                return GTK_UPDATE_ALWAYS
            case .ifValid:
                return GTK_UPDATE_IF_VALID
        }
    }
}

extension GtkSpinButtonUpdatePolicy {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSpinButtonUpdatePolicy() -> SpinButtonUpdatePolicy {
        switch self {
            case GTK_UPDATE_ALWAYS:
                return .always
            case GTK_UPDATE_IF_VALID:
                return .ifValid
            default:
                fatalError("Unsupported GtkSpinButtonUpdatePolicy enum value: \(self.rawValue)")
        }
    }
}
