import CGtk

/// Focus movement types.
public enum DirectionType {
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

    /// Converts the value to its corresponding Gtk representation.
    func toGtkDirectionType() -> GtkDirectionType {
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

extension GtkDirectionType {
    /// Converts a Gtk value to its corresponding swift representation.
    func toDirectionType() -> DirectionType {
        switch self {
            case GTK_DIR_TAB_FORWARD:
                return .tabForward
            case GTK_DIR_TAB_BACKWARD:
                return .tabBackward
            case GTK_DIR_UP:
                return .up
            case GTK_DIR_DOWN:
                return .down
            case GTK_DIR_LEFT:
                return .left
            case GTK_DIR_RIGHT:
                return .right
            default:
                fatalError("Unsupported GtkDirectionType enum value: \(self.rawValue)")
        }
    }
}
