import CGtk3

/// An enum for determining where a dropped item goes.
public enum IconViewDropPosition: GValueRepresentableEnum {
    public typealias GtkEnum = GtkIconViewDropPosition

    /// No drop possible
    case noDrop
    /// Dropped item replaces the item
    case dropInto
    /// Droppped item is inserted to the left
    case dropLeft
    /// Dropped item is inserted to the right
    case dropRight
    /// Dropped item is inserted above
    case dropAbove
    /// Dropped item is inserted below
    case dropBelow

    public static var type: GType {
        gtk_icon_view_drop_position_get_type()
    }

    public init(from gtkEnum: GtkIconViewDropPosition) {
        switch gtkEnum {
            case GTK_ICON_VIEW_NO_DROP:
                self = .noDrop
            case GTK_ICON_VIEW_DROP_INTO:
                self = .dropInto
            case GTK_ICON_VIEW_DROP_LEFT:
                self = .dropLeft
            case GTK_ICON_VIEW_DROP_RIGHT:
                self = .dropRight
            case GTK_ICON_VIEW_DROP_ABOVE:
                self = .dropAbove
            case GTK_ICON_VIEW_DROP_BELOW:
                self = .dropBelow
            default:
                fatalError("Unsupported GtkIconViewDropPosition enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkIconViewDropPosition {
        switch self {
            case .noDrop:
                return GTK_ICON_VIEW_NO_DROP
            case .dropInto:
                return GTK_ICON_VIEW_DROP_INTO
            case .dropLeft:
                return GTK_ICON_VIEW_DROP_LEFT
            case .dropRight:
                return GTK_ICON_VIEW_DROP_RIGHT
            case .dropAbove:
                return GTK_ICON_VIEW_DROP_ABOVE
            case .dropBelow:
                return GTK_ICON_VIEW_DROP_BELOW
        }
    }
}
