import CGtk

/// Describes the panning direction of a [class@GesturePan].
public enum PanDirection {
    /// Panned towards the left
    case left
    /// Panned towards the right
    case right
    /// Panned upwards
    case up
    /// Panned downwards
    case down

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPanDirection() -> GtkPanDirection {
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

extension GtkPanDirection {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPanDirection() -> PanDirection {
        switch self {
            case GTK_PAN_DIRECTION_LEFT:
                return .left
            case GTK_PAN_DIRECTION_RIGHT:
                return .right
            case GTK_PAN_DIRECTION_UP:
                return .up
            case GTK_PAN_DIRECTION_DOWN:
                return .down
            default:
                fatalError("Unsupported GtkPanDirection enum value: \(self.rawValue)")
        }
    }
}
