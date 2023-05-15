import CGtk

/// Describes which edge of a widget a certain feature is positioned at, e.g. the tabs of a
/// `GtkNotebook`, the handle of a `GtkHandleBox` or the label of a `GtkScale`.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.PositionType.html)
public enum PositionType {
    /// The feature is at the left edge.
    case left
    /// The feature is at the right edge.
    case right
    /// The feature is at the top edge.
    case top
    /// The feature is at the bottom edge.
    case bottom

    func toGtkPositionType() -> GtkPositionType {
        switch self {
            case .left:
                return GTK_POS_LEFT
            case .right:
                return GTK_POS_RIGHT
            case .top:
                return GTK_POS_TOP
            case .bottom:
                return GTK_POS_BOTTOM
        }
    }
}

extension GtkPositionType {
    func toPositionType() -> PositionType {
        switch self {
            case GTK_POS_LEFT:
                return .left
            case GTK_POS_RIGHT:
                return .right
            case GTK_POS_TOP:
                return .top
            case GTK_POS_BOTTOM:
                return .bottom
            default:
                fatalError("Unsupported GtkPositionType enum value: \(self.rawValue)")
        }
    }
}
