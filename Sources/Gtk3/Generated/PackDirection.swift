import CGtk3

/// Determines how widgets should be packed inside menubars
/// and menuitems contained in menubars.
public enum PackDirection: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPackDirection

    /// Widgets are packed left-to-right
    case ltr
    /// Widgets are packed right-to-left
    case rtl
    /// Widgets are packed top-to-bottom
    case ttb
    /// Widgets are packed bottom-to-top
    case btt

    public static var type: GType {
        gtk_pack_direction_get_type()
    }

    public init(from gtkEnum: GtkPackDirection) {
        switch gtkEnum {
            case GTK_PACK_DIRECTION_LTR:
                self = .ltr
            case GTK_PACK_DIRECTION_RTL:
                self = .rtl
            case GTK_PACK_DIRECTION_TTB:
                self = .ttb
            case GTK_PACK_DIRECTION_BTT:
                self = .btt
            default:
                fatalError("Unsupported GtkPackDirection enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPackDirection {
        switch self {
            case .ltr:
                return GTK_PACK_DIRECTION_LTR
            case .rtl:
                return GTK_PACK_DIRECTION_RTL
            case .ttb:
                return GTK_PACK_DIRECTION_TTB
            case .btt:
                return GTK_PACK_DIRECTION_BTT
        }
    }
}
