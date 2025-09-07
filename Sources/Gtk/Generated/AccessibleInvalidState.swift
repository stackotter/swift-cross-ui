import CGtk

/// The possible values for the %GTK_ACCESSIBLE_STATE_INVALID
/// accessible state.
///
/// Note that the %GTK_ACCESSIBLE_INVALID_FALSE and
/// %GTK_ACCESSIBLE_INVALID_TRUE have the same values
/// as %FALSE and %TRUE.
public enum AccessibleInvalidState: GValueRepresentableEnum {
    public typealias GtkEnum = GtkAccessibleInvalidState

    /// There are no detected errors in the value
    case false_
    /// The value entered by the user has failed validation
    case true_
    /// A grammatical error was detected
    case grammar
    /// A spelling error was detected
    case spelling

    public static var type: GType {
        gtk_accessible_invalid_state_get_type()
    }

    public init(from gtkEnum: GtkAccessibleInvalidState) {
        switch gtkEnum {
            case GTK_ACCESSIBLE_INVALID_FALSE:
                self = .false_
            case GTK_ACCESSIBLE_INVALID_TRUE:
                self = .true_
            case GTK_ACCESSIBLE_INVALID_GRAMMAR:
                self = .grammar
            case GTK_ACCESSIBLE_INVALID_SPELLING:
                self = .spelling
            default:
                fatalError("Unsupported GtkAccessibleInvalidState enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkAccessibleInvalidState {
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
