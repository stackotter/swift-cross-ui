import CGtk3

/// Window placement can be influenced using this enumeration. Note that
/// using #GTK_WIN_POS_CENTER_ALWAYS is almost always a bad idea.
/// It won’t necessarily work well with all window managers or on all windowing systems.
public enum WindowPosition: GValueRepresentableEnum {
    public typealias GtkEnum = GtkWindowPosition

    /// No influence is made on placement.
    case none
    /// Windows should be placed in the center of the screen.
    case center
    /// Windows should be placed at the current mouse position.
    case mouse
    /// Keep window centered as it changes size, etc.
    case centerAlways
    /// Center the window on its transient
    /// parent (see gtk_window_set_transient_for()).
    case centerOnParent

    public static var type: GType {
        gtk_window_position_get_type()
    }

    public init(from gtkEnum: GtkWindowPosition) {
        switch gtkEnum {
            case GTK_WIN_POS_NONE:
                self = .none
            case GTK_WIN_POS_CENTER:
                self = .center
            case GTK_WIN_POS_MOUSE:
                self = .mouse
            case GTK_WIN_POS_CENTER_ALWAYS:
                self = .centerAlways
            case GTK_WIN_POS_CENTER_ON_PARENT:
                self = .centerOnParent
            default:
                fatalError("Unsupported GtkWindowPosition enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkWindowPosition {
        switch self {
            case .none:
                return GTK_WIN_POS_NONE
            case .center:
                return GTK_WIN_POS_CENTER
            case .mouse:
                return GTK_WIN_POS_MOUSE
            case .centerAlways:
                return GTK_WIN_POS_CENTER_ALWAYS
            case .centerOnParent:
                return GTK_WIN_POS_CENTER_ON_PARENT
        }
    }
}
