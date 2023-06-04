import CGtk

/// The possible values for the %GTK_ACCESSIBLE_STATE_PRESSED
/// accessible state.
///
/// Note that the %GTK_ACCESSIBLE_TRISTATE_FALSE and
/// %GTK_ACCESSIBLE_TRISTATE_TRUE have the same values
/// as %FALSE and %TRUE.
public enum AccessibleTristate {
    /// The state is `false`
    case false_
    /// The state is `true`
    case true_
    /// The state is `mixed`
    case mixed

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessibleTristate() -> GtkAccessibleTristate {
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

extension GtkAccessibleTristate {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessibleTristate() -> AccessibleTristate {
        switch self {
            case GTK_ACCESSIBLE_TRISTATE_FALSE:
                return .false_
            case GTK_ACCESSIBLE_TRISTATE_TRUE:
                return .true_
            case GTK_ACCESSIBLE_TRISTATE_MIXED:
                return .mixed
            default:
                fatalError("Unsupported GtkAccessibleTristate enum value: \(self.rawValue)")
        }
    }
}
