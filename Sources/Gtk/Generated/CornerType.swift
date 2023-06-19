import CGtk

/// Specifies which corner a child widget should be placed in when packed into
/// a `GtkScrolledWindow.`
///
/// This is effectively the opposite of where the scroll bars are placed.
public enum CornerType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkCornerType

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

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkCornerType) {
        switch gtkEnum {
            case GTK_CORNER_TOP_LEFT:
                self = .topLeft
            case GTK_CORNER_BOTTOM_LEFT:
                self = .bottomLeft
            case GTK_CORNER_TOP_RIGHT:
                self = .topRight
            case GTK_CORNER_BOTTOM_RIGHT:
                self = .bottomRight
            default:
                fatalError("Unsupported GtkCornerType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkCornerType {
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
