import CGtk3

/// Priorities for path lookups.
/// See also gtk_binding_set_add_path().
public enum PathPriorityType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPathPriorityType

    /// Deprecated
    case lowest
    /// Deprecated
    case gtk
    /// Deprecated
    case application
    /// Deprecated
    case theme
    /// Deprecated
    case rc
    /// Deprecated
    case highest

    public static var type: GType {
        gtk_path_priority_type_get_type()
    }

    public init(from gtkEnum: GtkPathPriorityType) {
        switch gtkEnum {
            case GTK_PATH_PRIO_LOWEST:
                self = .lowest
            case GTK_PATH_PRIO_GTK:
                self = .gtk
            case GTK_PATH_PRIO_APPLICATION:
                self = .application
            case GTK_PATH_PRIO_THEME:
                self = .theme
            case GTK_PATH_PRIO_RC:
                self = .rc
            case GTK_PATH_PRIO_HIGHEST:
                self = .highest
            default:
                fatalError("Unsupported GtkPathPriorityType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPathPriorityType {
        switch self {
            case .lowest:
                return GTK_PATH_PRIO_LOWEST
            case .gtk:
                return GTK_PATH_PRIO_GTK
            case .application:
                return GTK_PATH_PRIO_APPLICATION
            case .theme:
                return GTK_PATH_PRIO_THEME
            case .rc:
                return GTK_PATH_PRIO_RC
            case .highest:
                return GTK_PATH_PRIO_HIGHEST
        }
    }
}
