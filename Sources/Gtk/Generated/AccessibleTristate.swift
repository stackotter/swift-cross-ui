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

    public static var type: GType {
        gtk_accessible_tristate_get_type()
    }

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
