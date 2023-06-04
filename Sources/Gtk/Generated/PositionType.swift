import CGtk

/// Describes which edge of a widget a certain feature is positioned at.
///
/// For examples, see the tabs of a [class@Notebook], or the label
/// of a [class@Scale].
public enum PositionType {
    /// The feature is at the left edge.
    case left
    /// The feature is at the right edge.
    case right
    /// The feature is at the top edge.
    case top
    /// The feature is at the bottom edge.
    case bottom

    /// Converts the value to its corresponding Gtk representation.
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
    /// Converts a Gtk value to its corresponding swift representation.
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
