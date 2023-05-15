import CGtk

/// The spin button update policy determines whether the spin button displays values even if they are outside the bounds of its adjustment. See `gtk_spin_button_set_update_policy()`.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.SpinButtonUpdatePolicy.html)
public enum SpinButtonUpdatePolicy {
    /// When refreshing your GtkSpinButton, the value is always displayed.
    case always
    /// When refreshing your GtkSpinButton, the value is only displayed if it is valid within the bounds of the spin button’s adjustment.
    case ifValid

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
