import CGtk

/// Focus movement types.
public enum DirectionType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkDirectionType

    /// Move forward.
    case tabForward
    /// Move backward.
    case tabBackward
    /// Move up.
    case up
    /// Move down.
    case down
    /// Move left.
    case left
    /// Move right.
    case right

    public static var type: GType {
        gtk_direction_type_get_type()
    }

    public init(from gtkEnum: GtkDirectionType) {
        switch gtkEnum {
            case GTK_DIR_TAB_FORWARD:
                self = .tabForward
            case GTK_DIR_TAB_BACKWARD:
                self = .tabBackward
            case GTK_DIR_UP:
                self = .up
            case GTK_DIR_DOWN:
                self = .down
            case GTK_DIR_LEFT:
                self = .left
            case GTK_DIR_RIGHT:
                self = .right
            default:
                fatalError("Unsupported GtkDirectionType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkDirectionType {
        switch self {
            case .tabForward:
                return GTK_DIR_TAB_FORWARD
            case .tabBackward:
                return GTK_DIR_TAB_BACKWARD
            case .up:
                return GTK_DIR_UP
            case .down:
                return GTK_DIR_DOWN
            case .left:
                return GTK_DIR_LEFT
            case .right:
                return GTK_DIR_RIGHT
        }
    }
}
