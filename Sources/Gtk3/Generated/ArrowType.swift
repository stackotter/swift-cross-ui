import CGtk3

/// Used to indicate the direction in which an arrow should point.
public enum ArrowType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkArrowType

    /// Represents an upward pointing arrow.
    case up
    /// Represents a downward pointing arrow.
    case down
    /// Represents a left pointing arrow.
    case left
    /// Represents a right pointing arrow.
    case right

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkArrowType) {
        switch gtkEnum {
            case GTK_ARROW_UP:
                self = .up
            case GTK_ARROW_DOWN:
                self = .down
            case GTK_ARROW_LEFT:
                self = .left
            case GTK_ARROW_RIGHT:
                self = .right
            default:
                fatalError("Unsupported GtkArrowType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkArrowType {
        switch self {
            case .up:
                return GTK_ARROW_UP
            case .down:
                return GTK_ARROW_DOWN
            case .left:
                return GTK_ARROW_LEFT
            case .right:
                return GTK_ARROW_RIGHT
        }
    }
}
