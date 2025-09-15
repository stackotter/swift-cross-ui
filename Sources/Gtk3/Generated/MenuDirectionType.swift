import CGtk3

/// An enumeration representing directional movements within a menu.
public enum MenuDirectionType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkMenuDirectionType

    /// To the parent menu shell
    case parent
    /// To the submenu, if any, associated with the item
    case child
    /// To the next menu item
    case next
    /// To the previous menu item
    case prev

    public static var type: GType {
        gtk_menu_direction_type_get_type()
    }

    public init(from gtkEnum: GtkMenuDirectionType) {
        switch gtkEnum {
            case GTK_MENU_DIR_PARENT:
                self = .parent
            case GTK_MENU_DIR_CHILD:
                self = .child
            case GTK_MENU_DIR_NEXT:
                self = .next
            case GTK_MENU_DIR_PREV:
                self = .prev
            default:
                fatalError("Unsupported GtkMenuDirectionType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkMenuDirectionType {
        switch self {
            case .parent:
                return GTK_MENU_DIR_PARENT
            case .child:
                return GTK_MENU_DIR_CHILD
            case .next:
                return GTK_MENU_DIR_NEXT
            case .prev:
                return GTK_MENU_DIR_PREV
        }
    }
}
