import CGtk

/// Describes the panning direction of a [class@GesturePan].
public enum PanDirection: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPanDirection

    /// Panned towards the left
    case left
    /// Panned towards the right
    case right
    /// Panned upwards
    case up
    /// Panned downwards
    case down

    public static var type: GType {
        gtk_pan_direction_get_type()
    }

    public init(from gtkEnum: GtkPanDirection) {
        switch gtkEnum {
            case GTK_PAN_DIRECTION_LEFT:
                self = .left
            case GTK_PAN_DIRECTION_RIGHT:
                self = .right
            case GTK_PAN_DIRECTION_UP:
                self = .up
            case GTK_PAN_DIRECTION_DOWN:
                self = .down
            default:
                fatalError("Unsupported GtkPanDirection enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPanDirection {
        switch self {
            case .left:
                return GTK_PAN_DIRECTION_LEFT
            case .right:
                return GTK_PAN_DIRECTION_RIGHT
            case .up:
                return GTK_PAN_DIRECTION_UP
            case .down:
                return GTK_PAN_DIRECTION_DOWN
        }
    }
}
