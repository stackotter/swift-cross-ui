import CGtk

/// The possible values for the %GTK_ACCESSIBLE_STATE_PRESSED
/// accessible state.
///
/// Note that the %GTK_ACCESSIBLE_TRISTATE_FALSE and
/// %GTK_ACCESSIBLE_TRISTATE_TRUE have the same values
/// as %FALSE and %TRUE.
public enum AccessibleTristate: GValueRepresentableEnum {
    public typealias GtkEnum = GtkAccessibleTristate

    /// The state is `false`
    case false_
    /// The state is `true`
    case true_
    /// The state is `mixed`
    case mixed

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkAccessibleTristate) {
        switch gtkEnum {
            case GTK_ACCESSIBLE_TRISTATE_FALSE:
                self = .false_
            case GTK_ACCESSIBLE_TRISTATE_TRUE:
                self = .true_
            case GTK_ACCESSIBLE_TRISTATE_MIXED:
                self = .mixed
            default:
                fatalError("Unsupported GtkAccessibleTristate enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkAccessibleTristate {
        switch self {
            case .false_:
                return GTK_ACCESSIBLE_TRISTATE_FALSE
            case .true_:
                return GTK_ACCESSIBLE_TRISTATE_TRUE
            case .mixed:
                return GTK_ACCESSIBLE_TRISTATE_MIXED
        }
    }
}
