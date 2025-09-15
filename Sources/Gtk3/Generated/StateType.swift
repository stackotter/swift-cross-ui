import CGtk3

/// This type indicates the current state of a widget; the state determines how
/// the widget is drawn. The #GtkStateType enumeration is also used to
/// identify different colors in a #GtkStyle for drawing, so states can be
/// used for subparts of a widget as well as entire widgets.
public enum StateType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkStateType

    /// State during normal operation.
    case normal
    /// State of a currently active widget, such as a depressed button.
    case active
    /// State indicating that the mouse pointer is over
    /// the widget and the widget will respond to mouse clicks.
    case prelight
    /// State of a selected item, such the selected row in a list.
    case selected
    /// State indicating that the widget is
    /// unresponsive to user actions.
    case insensitive
    /// The widget is inconsistent, such as checkbuttons
    /// or radiobuttons that aren’t either set to %TRUE nor %FALSE,
    /// or buttons requiring the user attention.
    case inconsistent
    /// The widget has the keyboard focus.
    case focused

    public static var type: GType {
        gtk_state_type_get_type()
    }

    public init(from gtkEnum: GtkStateType) {
        switch gtkEnum {
            case GTK_STATE_NORMAL:
                self = .normal
            case GTK_STATE_ACTIVE:
                self = .active
            case GTK_STATE_PRELIGHT:
                self = .prelight
            case GTK_STATE_SELECTED:
                self = .selected
            case GTK_STATE_INSENSITIVE:
                self = .insensitive
            case GTK_STATE_INCONSISTENT:
                self = .inconsistent
            case GTK_STATE_FOCUSED:
                self = .focused
            default:
                fatalError("Unsupported GtkStateType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkStateType {
        switch self {
            case .normal:
                return GTK_STATE_NORMAL
            case .active:
                return GTK_STATE_ACTIVE
            case .prelight:
                return GTK_STATE_PRELIGHT
            case .selected:
                return GTK_STATE_SELECTED
            case .insensitive:
                return GTK_STATE_INSENSITIVE
            case .inconsistent:
                return GTK_STATE_INCONSISTENT
            case .focused:
                return GTK_STATE_FOCUSED
        }
    }
}
