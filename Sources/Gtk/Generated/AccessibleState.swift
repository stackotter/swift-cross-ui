import CGtk

/// The possible accessible states of a [iface@Accessible].
public enum AccessibleState: GValueRepresentableEnum {
    public typealias GtkEnum = GtkAccessibleState

    /// A “busy” state. This state has boolean values
    case busy
    /// A “checked” state; indicates the current
    /// state of a [class@CheckButton]. Value type: [enum@AccessibleTristate]
    case checked
    /// A “disabled” state; corresponds to the
    /// [property@Widget:sensitive] property. It indicates a UI element
    /// that is perceivable, but not editable or operable. Value type: boolean
    case disabled
    /// An “expanded” state; corresponds to the
    /// [property@Expander:expanded] property. Value type: boolean
    /// or undefined
    case expanded
    /// A “hidden” state; corresponds to the
    /// [property@Widget:visible] property. You can use this state
    /// explicitly on UI elements that should not be exposed to an assistive
    /// technology. Value type: boolean
    /// See also: %GTK_ACCESSIBLE_STATE_DISABLED
    case hidden
    /// An “invalid” state; set when a widget
    /// is showing an error. Value type: [enum@AccessibleInvalidState]
    case invalid
    /// A “pressed” state; indicates the current
    /// state of a [class@ToggleButton]. Value type: [enum@AccessibleTristate]
    /// enumeration
    case pressed
    /// A “selected” state; set when a widget
    /// is selected. Value type: boolean or undefined
    case selected

    public static var type: GType {
        gtk_accessible_state_get_type()
    }

    public init(from gtkEnum: GtkAccessibleState) {
        switch gtkEnum {
            case GTK_ACCESSIBLE_STATE_BUSY:
                self = .busy
            case GTK_ACCESSIBLE_STATE_CHECKED:
                self = .checked
            case GTK_ACCESSIBLE_STATE_DISABLED:
                self = .disabled
            case GTK_ACCESSIBLE_STATE_EXPANDED:
                self = .expanded
            case GTK_ACCESSIBLE_STATE_HIDDEN:
                self = .hidden
            case GTK_ACCESSIBLE_STATE_INVALID:
                self = .invalid
            case GTK_ACCESSIBLE_STATE_PRESSED:
                self = .pressed
            case GTK_ACCESSIBLE_STATE_SELECTED:
                self = .selected
            default:
                fatalError("Unsupported GtkAccessibleState enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkAccessibleState {
        switch self {
            case .busy:
                return GTK_ACCESSIBLE_STATE_BUSY
            case .checked:
                return GTK_ACCESSIBLE_STATE_CHECKED
            case .disabled:
                return GTK_ACCESSIBLE_STATE_DISABLED
            case .expanded:
                return GTK_ACCESSIBLE_STATE_EXPANDED
            case .hidden:
                return GTK_ACCESSIBLE_STATE_HIDDEN
            case .invalid:
                return GTK_ACCESSIBLE_STATE_INVALID
            case .pressed:
                return GTK_ACCESSIBLE_STATE_PRESSED
            case .selected:
                return GTK_ACCESSIBLE_STATE_SELECTED
        }
    }
}
