import CGtk

/// The possible values for the %GTK_ACCESSIBLE_STATE_INVALID
/// accessible state.
///
/// Note that the %GTK_ACCESSIBLE_INVALID_FALSE and
/// %GTK_ACCESSIBLE_INVALID_TRUE have the same values
/// as %FALSE and %TRUE.
public enum AccessibleInvalidState {
    /// There are no detected errors in the value
    case false_
    /// The value entered by the user has failed validation
    case true_
    /// A grammatical error was detected
    case grammar
    /// A spelling error was detected
    case spelling

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessibleInvalidState() -> GtkAccessibleInvalidState {
        switch self {
            case .false_:
                return GTK_ACCESSIBLE_INVALID_FALSE
            case .true_:
                return GTK_ACCESSIBLE_INVALID_TRUE
            case .grammar:
                return GTK_ACCESSIBLE_INVALID_GRAMMAR
            case .spelling:
                return GTK_ACCESSIBLE_INVALID_SPELLING
        }
    }
}

extension GtkAccessibleInvalidState {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessibleInvalidState() -> AccessibleInvalidState {
        switch self {
            case GTK_ACCESSIBLE_INVALID_FALSE:
                return .false_
            case GTK_ACCESSIBLE_INVALID_TRUE:
                return .true_
            case GTK_ACCESSIBLE_INVALID_GRAMMAR:
                return .grammar
            case GTK_ACCESSIBLE_INVALID_SPELLING:
                return .spelling
            default:
                fatalError("Unsupported GtkAccessibleInvalidState enum value: \(self.rawValue)")
        }
    }
}
