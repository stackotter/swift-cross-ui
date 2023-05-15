import CGtk

/// The values of the GtkSpinType enumeration are used to specify the change to make in gtk_spin_button_spin().
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.SpinType.html)
public enum SpinType {
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

    func toGtkSpinType() -> GtkSpinType {
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

extension GtkSpinType {
    func toSpinType() -> SpinType {
        switch self {
            case GTK_SPIN_STEP_FORWARD:
                return .stepForward
            case GTK_SPIN_STEP_BACKWARD:
                return .stepBackward
            case GTK_SPIN_PAGE_FORWARD:
                return .pageForward
            case GTK_SPIN_PAGE_BACKWARD:
                return .pageBackward
            case GTK_SPIN_HOME:
                return .home
            case GTK_SPIN_END:
                return .end
            case GTK_SPIN_USER_DEFINED:
                return .userDefined
            default:
                fatalError("Unsupported GtkSpinType enum value: \(self.rawValue)")
        }
    }
}
