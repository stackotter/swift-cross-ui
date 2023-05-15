import CGtk

public enum StateFlags {
    /// State during normal operation.
    case normal
    /// Widget is active.
    case active
    /// Widget has a mouse pointer over it.
    case prelight
    /// Widget is selected.
    case selected
    /// Widget is insensitive.
    case insensitive
    /// Widget is inconsistent.
    case inconsistent
    /// Widget has the keyboard focus.
    case focused
    /// Widget is in a background toplevel window.
    case backdrop
    /// Widget is in left-to-right text direction.
    case dir_ltr
    /// Widget is in right-to-left text direction.
    case dir_rtl
    /// Widget is a link.
    case link
    /// The location the widget points to has already been visited.
    case visited
    /// Widget is checked.
    case checked
    /// Widget is highlighted as a drop target for DND.
    case drop_active
    /// Widget has the visible focus.
    case focus_visible
    /// Widget contains the keyboard focus.
    case focus_within

    public init?(rawValue: GtkStateFlags) {
        switch rawValue {
            case GTK_STATE_FLAG_NORMAL:
                self = .normal
            case GTK_STATE_FLAG_ACTIVE:
                self = .active
            case GTK_STATE_FLAG_PRELIGHT:
                self = .prelight
            case GTK_STATE_FLAG_SELECTED:
                self = .selected
            case GTK_STATE_FLAG_INSENSITIVE:
                self = .insensitive
            case GTK_STATE_FLAG_INCONSISTENT:
                self = .inconsistent
            case GTK_STATE_FLAG_FOCUSED:
                self = .focused
            case GTK_STATE_FLAG_BACKDROP:
                self = .backdrop
            case GTK_STATE_FLAG_DIR_LTR:
                self = .dir_ltr
            case GTK_STATE_FLAG_DIR_RTL:
                self = .dir_rtl
            case GTK_STATE_FLAG_LINK:
                self = .link
            case GTK_STATE_FLAG_VISITED:
                self = .visited
            case GTK_STATE_FLAG_CHECKED:
                self = .checked
            case GTK_STATE_FLAG_DROP_ACTIVE:
                self = .drop_active
            case GTK_STATE_FLAG_FOCUS_VISIBLE:
                self = .focus_visible
            case GTK_STATE_FLAG_FOCUS_WITHIN:
                self = .focus_within
            default:
                return nil
        }
    }

    public var rawValue: GtkStateFlags {
        switch self {
            case .normal:
                return GTK_STATE_FLAG_NORMAL
            case .active:
                return GTK_STATE_FLAG_ACTIVE
            case .prelight:
                return GTK_STATE_FLAG_PRELIGHT
            case .selected:
                return GTK_STATE_FLAG_SELECTED
            case .insensitive:
                return GTK_STATE_FLAG_INSENSITIVE
            case .inconsistent:
                return GTK_STATE_FLAG_INCONSISTENT
            case .focused:
                return GTK_STATE_FLAG_FOCUSED
            case .backdrop:
                return GTK_STATE_FLAG_BACKDROP
            case .dir_ltr:
                return GTK_STATE_FLAG_DIR_LTR
            case .dir_rtl:
                return GTK_STATE_FLAG_DIR_RTL
            case .link:
                return GTK_STATE_FLAG_LINK
            case .visited:
                return GTK_STATE_FLAG_VISITED
            case .checked:
                return GTK_STATE_FLAG_CHECKED
            case .drop_active:
                return GTK_STATE_FLAG_DROP_ACTIVE
            case .focus_visible:
                return GTK_STATE_FLAG_FOCUS_VISIBLE
            case .focus_within:
                return GTK_STATE_FLAG_FOCUS_WITHIN
        }
    }
}
