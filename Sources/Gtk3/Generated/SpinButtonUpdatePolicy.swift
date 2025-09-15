import CGtk3

/// The spin button update policy determines whether the spin button displays
/// values even if they are outside the bounds of its adjustment.
/// See gtk_spin_button_set_update_policy().
public enum SpinButtonUpdatePolicy: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSpinButtonUpdatePolicy

    /// When refreshing your #GtkSpinButton, the value is
    /// always displayed
    case always
    /// When refreshing your #GtkSpinButton, the value is
    /// only displayed if it is valid within the bounds of the spin button's
    /// adjustment
    case ifValid

    public static var type: GType {
        gtk_spin_button_update_policy_get_type()
    }

    public init(from gtkEnum: GtkSpinButtonUpdatePolicy) {
        switch gtkEnum {
            case GTK_UPDATE_ALWAYS:
                self = .always
            case GTK_UPDATE_IF_VALID:
                self = .ifValid
            default:
                fatalError("Unsupported GtkSpinButtonUpdatePolicy enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkSpinButtonUpdatePolicy {
        switch self {
            case .always:
                return GTK_UPDATE_ALWAYS
            case .ifValid:
                return GTK_UPDATE_IF_VALID
        }
    }
}
