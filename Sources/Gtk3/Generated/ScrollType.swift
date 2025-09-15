import CGtk3

/// Scrolling types.
public enum ScrollType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkScrollType

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

    public static var type: GType {
        gtk_scroll_type_get_type()
    }

    public init(from gtkEnum: GtkScrollType) {
        switch gtkEnum {
            case GTK_SCROLL_NONE:
                self = .none
            case GTK_SCROLL_JUMP:
                self = .jump
            case GTK_SCROLL_STEP_BACKWARD:
                self = .stepBackward
            case GTK_SCROLL_STEP_FORWARD:
                self = .stepForward
            case GTK_SCROLL_PAGE_BACKWARD:
                self = .pageBackward
            case GTK_SCROLL_PAGE_FORWARD:
                self = .pageForward
            case GTK_SCROLL_STEP_UP:
                self = .stepUp
            case GTK_SCROLL_STEP_DOWN:
                self = .stepDown
            case GTK_SCROLL_PAGE_UP:
                self = .pageUp
            case GTK_SCROLL_PAGE_DOWN:
                self = .pageDown
            case GTK_SCROLL_STEP_LEFT:
                self = .stepLeft
            case GTK_SCROLL_STEP_RIGHT:
                self = .stepRight
            case GTK_SCROLL_PAGE_LEFT:
                self = .pageLeft
            case GTK_SCROLL_PAGE_RIGHT:
                self = .pageRight
            case GTK_SCROLL_START:
                self = .start
            case GTK_SCROLL_END:
                self = .end
            default:
                fatalError("Unsupported GtkScrollType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkScrollType {
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
