import CGtk

/// Used to indicate the direction in which an arrow should point.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ArrowType.html)
public enum ArrowType {
    /// Represents an upward pointing arrow.
    case up
    /// Represents a downward pointing arrow.
    case down
    /// Represents a left pointing arrow.
    case left
    /// Represents a right pointing arrow.
    case right
    /// No arrow. Since 2.10.
    case none

    func toGtkArrowType() -> GtkArrowType {
        switch self {
        case .up:
            return GTK_ARROW_UP
        case .down:
            return GTK_ARROW_DOWN
        case .left:
            return GTK_ARROW_LEFT
        case .right:
            return GTK_ARROW_RIGHT
        case .none:
            return GTK_ARROW_NONE
        }
    }
}

extension GtkArrowType {
    func toArrowType() -> ArrowType {
        switch self {
        case GTK_ARROW_UP:
            return .up
        case GTK_ARROW_DOWN:
            return .down
        case GTK_ARROW_LEFT:
            return .left
        case GTK_ARROW_RIGHT:
            return .right
        case GTK_ARROW_NONE:
            return ArrowType.none
        default:
            fatalError("Unsupported GtkArrowType enum value: \(self.rawValue)")
        }
    }
}
