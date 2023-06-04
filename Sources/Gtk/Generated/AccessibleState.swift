import CGtk

/// The possible accessible states of a [iface@Accessible].
public enum AccessibleState {
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

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessibleState() -> GtkAccessibleState {
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

extension GtkAccessibleState {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessibleState() -> AccessibleState {
        switch self {
            case GTK_ACCESSIBLE_STATE_BUSY:
                return .busy
            case GTK_ACCESSIBLE_STATE_CHECKED:
                return .checked
            case GTK_ACCESSIBLE_STATE_DISABLED:
                return .disabled
            case GTK_ACCESSIBLE_STATE_EXPANDED:
                return .expanded
            case GTK_ACCESSIBLE_STATE_HIDDEN:
                return .hidden
            case GTK_ACCESSIBLE_STATE_INVALID:
                return .invalid
            case GTK_ACCESSIBLE_STATE_PRESSED:
                return .pressed
            case GTK_ACCESSIBLE_STATE_SELECTED:
                return .selected
            default:
                fatalError("Unsupported GtkAccessibleState enum value: \(self.rawValue)")
        }
    }
}
