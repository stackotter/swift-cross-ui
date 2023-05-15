import CGtk

/// An enum for determining where a dropped item goes.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.IconViewDropPosition.html)
public enum IconViewDropPosition {
    /// No drop possible.
    case noDrop
    /// Dropped item replaces the item.
    case dropInto
    /// Droppped item is inserted to the left.
    case dropLeft
    /// Dropped item is inserted to the right.
    case dropRight
    /// Dropped item is inserted above.
    case dropAbove
    /// Dropped item is inserted below.
    case dropBelow

    func toGtkIconViewDropPosition() -> GtkIconViewDropPosition {
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

extension GtkIconViewDropPosition {
    func toIconViewDropPosition() -> IconViewDropPosition {
        switch self {
            case GTK_ICON_VIEW_NO_DROP:
                return .noDrop
            case GTK_ICON_VIEW_DROP_INTO:
                return .dropInto
            case GTK_ICON_VIEW_DROP_LEFT:
                return .dropLeft
            case GTK_ICON_VIEW_DROP_RIGHT:
                return .dropRight
            case GTK_ICON_VIEW_DROP_ABOVE:
                return .dropAbove
            case GTK_ICON_VIEW_DROP_BELOW:
                return .dropBelow
            default:
                fatalError("Unsupported GtkIconViewDropPosition enum value: \(self.rawValue)")
        }
    }
}
