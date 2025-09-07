import CGtk

/// The values of the GtkSpinType enumeration are used to specify the
/// change to make in gtk_spin_button_spin().
public enum SpinType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSpinType

    /// Increment by the adjustments step increment.
    case stepForward
    /// Decrement by the adjustments step increment.
    case stepBackward
    /// Increment by the adjustments page increment.
    case pageForward
    /// Decrement by the adjustments page increment.
    case pageBackward
    /// Go to the adjustments lower bound.
    case home
    /// Go to the adjustments upper bound.
    case end
    /// Change by a specified amount.
    case userDefined

    public static var type: GType {
        gtk_spin_type_get_type()
    }

    public init(from gtkEnum: GtkSpinType) {
        switch gtkEnum {
            case GTK_SPIN_STEP_FORWARD:
                self = .stepForward
            case GTK_SPIN_STEP_BACKWARD:
                self = .stepBackward
            case GTK_SPIN_PAGE_FORWARD:
                self = .pageForward
            case GTK_SPIN_PAGE_BACKWARD:
                self = .pageBackward
            case GTK_SPIN_HOME:
                self = .home
            case GTK_SPIN_END:
                self = .end
            case GTK_SPIN_USER_DEFINED:
                self = .userDefined
            default:
                fatalError("Unsupported GtkSpinType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkSpinType {
        switch self {
            case .stepForward:
                return GTK_SPIN_STEP_FORWARD
            case .stepBackward:
                return GTK_SPIN_STEP_BACKWARD
            case .pageForward:
                return GTK_SPIN_PAGE_FORWARD
            case .pageBackward:
                return GTK_SPIN_PAGE_BACKWARD
            case .home:
                return GTK_SPIN_HOME
            case .end:
                return GTK_SPIN_END
            case .userDefined:
                return GTK_SPIN_USER_DEFINED
        }
    }
}
