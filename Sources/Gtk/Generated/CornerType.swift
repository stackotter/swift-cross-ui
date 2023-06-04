import CGtk

/// Specifies which corner a child widget should be placed in when packed into
/// a `GtkScrolledWindow.`
///
/// This is effectively the opposite of where the scroll bars are placed.
public enum CornerType {
    /// Place the scrollbars on the right and bottom of the
    /// widget (default behaviour).
    case topLeft
    /// Place the scrollbars on the top and right of the
    /// widget.
    case bottomLeft
    /// Place the scrollbars on the left and bottom of the
    /// widget.
    case topRight
    /// Place the scrollbars on the top and left of the
    /// widget.
    case bottomRight

    /// Converts the value to its corresponding Gtk representation.
    func toGtkCornerType() -> GtkCornerType {
        switch self {
            case .topLeft:
                return GTK_CORNER_TOP_LEFT
            case .bottomLeft:
                return GTK_CORNER_BOTTOM_LEFT
            case .topRight:
                return GTK_CORNER_TOP_RIGHT
            case .bottomRight:
                return GTK_CORNER_BOTTOM_RIGHT
        }
    }
}

extension GtkCornerType {
    /// Converts a Gtk value to its corresponding swift representation.
    func toCornerType() -> CornerType {
        switch self {
            case GTK_CORNER_TOP_LEFT:
                return .topLeft
            case GTK_CORNER_BOTTOM_LEFT:
                return .bottomLeft
            case GTK_CORNER_TOP_RIGHT:
                return .topRight
            case GTK_CORNER_BOTTOM_RIGHT:
                return .bottomRight
            default:
                fatalError("Unsupported GtkCornerType enum value: \(self.rawValue)")
        }
    }
}
