import CGtk

/// Scrolling types.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ScrollType.html)
public enum ScrollType {
    /// No scrolling.
    case none
    /// Jump to new location.
    case jump
    /// Step backward.
    case stepBackward
    /// Step forward.
    case stepForward
    /// Page backward.
    case pageBackward
    /// Page forward.
    case pageForward
    /// Step up.
    case stepUp
    /// Step down.
    case stepDown
    /// Page up.
    case pageUp
    /// Page down.
    case pageDown
    /// Step to the left.
    case stepLeft
    /// Step to the right.
    case stepRight
    /// Page to the left.
    case pageLeft
    /// Page to the right.
    case pageRight
    /// Scroll to start.
    case start
    /// Scroll to end.
    case end

    func toGtkScrollType() -> GtkScrollType {
        switch self {
            case .none:
                return GTK_SCROLL_NONE
            case .jump:
                return GTK_SCROLL_JUMP
            case .stepBackward:
                return GTK_SCROLL_STEP_BACKWARD
            case .stepForward:
                return GTK_SCROLL_STEP_FORWARD
            case .pageBackward:
                return GTK_SCROLL_PAGE_BACKWARD
            case .pageForward:
                return GTK_SCROLL_PAGE_FORWARD
            case .stepUp:
                return GTK_SCROLL_STEP_UP
            case .stepDown:
                return GTK_SCROLL_STEP_DOWN
            case .pageUp:
                return GTK_SCROLL_PAGE_UP
            case .pageDown:
                return GTK_SCROLL_PAGE_DOWN
            case .stepLeft:
                return GTK_SCROLL_STEP_LEFT
            case .stepRight:
                return GTK_SCROLL_STEP_RIGHT
            case .pageLeft:
                return GTK_SCROLL_PAGE_LEFT
            case .pageRight:
                return GTK_SCROLL_PAGE_RIGHT
            case .start:
                return GTK_SCROLL_START
            case .end:
                return GTK_SCROLL_END
        }
    }
}

extension GtkScrollType {
    func toScrollType() -> ScrollType {
        switch self {
            case GTK_SCROLL_NONE:
                return ScrollType.none
            case GTK_SCROLL_JUMP:
                return .jump
            case GTK_SCROLL_STEP_BACKWARD:
                return .stepBackward
            case GTK_SCROLL_STEP_FORWARD:
                return .stepForward
            case GTK_SCROLL_PAGE_BACKWARD:
                return .pageBackward
            case GTK_SCROLL_PAGE_FORWARD:
                return .pageForward
            case GTK_SCROLL_STEP_UP:
                return .stepUp
            case GTK_SCROLL_STEP_DOWN:
                return .stepDown
            case GTK_SCROLL_PAGE_UP:
                return .pageUp
            case GTK_SCROLL_PAGE_DOWN:
                return .pageDown
            case GTK_SCROLL_STEP_LEFT:
                return .stepLeft
            case GTK_SCROLL_STEP_RIGHT:
                return .stepRight
            case GTK_SCROLL_PAGE_LEFT:
                return .pageLeft
            case GTK_SCROLL_PAGE_RIGHT:
                return .pageRight
            case GTK_SCROLL_START:
                return .start
            case GTK_SCROLL_END:
                return .end
            default:
                fatalError("Unsupported GtkScrollType enum value: \(self.rawValue)")
        }
    }
}
