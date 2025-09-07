import CGtk

/// Possible transitions between pages in a `GtkStack` widget.
///
/// New values may be added to this enumeration over time.
public enum StackTransitionType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkStackTransitionType

    /// No transition
    case none
    /// A cross-fade
    case crossfade
    /// Slide from left to right
    case slideRight
    /// Slide from right to left
    case slideLeft
    /// Slide from bottom up
    case slideUp
    /// Slide from top down
    case slideDown
    /// Slide from left or right according to the children order
    case slideLeftRight
    /// Slide from top down or bottom up according to the order
    case slideUpDown
    /// Cover the old page by sliding up
    case overUp
    /// Cover the old page by sliding down
    case overDown
    /// Cover the old page by sliding to the left
    case overLeft
    /// Cover the old page by sliding to the right
    case overRight
    /// Uncover the new page by sliding up
    case underUp
    /// Uncover the new page by sliding down
    case underDown
    /// Uncover the new page by sliding to the left
    case underLeft
    /// Uncover the new page by sliding to the right
    case underRight
    /// Cover the old page sliding up or uncover the new page sliding down, according to order
    case overUpDown
    /// Cover the old page sliding down or uncover the new page sliding up, according to order
    case overDownUp
    /// Cover the old page sliding left or uncover the new page sliding right, according to order
    case overLeftRight
    /// Cover the old page sliding right or uncover the new page sliding left, according to order
    case overRightLeft
    /// Pretend the pages are sides of a cube and rotate that cube to the left
    case rotateLeft
    /// Pretend the pages are sides of a cube and rotate that cube to the right
    case rotateRight
    /// Pretend the pages are sides of a cube and rotate that cube to the left or right according to the children order
    case rotateLeftRight

    public static var type: GType {
        gtk_stack_transition_type_get_type()
    }

    public init(from gtkEnum: GtkStackTransitionType) {
        switch gtkEnum {
            case GTK_STACK_TRANSITION_TYPE_NONE:
                self = .none
            case GTK_STACK_TRANSITION_TYPE_CROSSFADE:
                self = .crossfade
            case GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT:
                self = .slideRight
            case GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT:
                self = .slideLeft
            case GTK_STACK_TRANSITION_TYPE_SLIDE_UP:
                self = .slideUp
            case GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN:
                self = .slideDown
            case GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT:
                self = .slideLeftRight
            case GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN:
                self = .slideUpDown
            case GTK_STACK_TRANSITION_TYPE_OVER_UP:
                self = .overUp
            case GTK_STACK_TRANSITION_TYPE_OVER_DOWN:
                self = .overDown
            case GTK_STACK_TRANSITION_TYPE_OVER_LEFT:
                self = .overLeft
            case GTK_STACK_TRANSITION_TYPE_OVER_RIGHT:
                self = .overRight
            case GTK_STACK_TRANSITION_TYPE_UNDER_UP:
                self = .underUp
            case GTK_STACK_TRANSITION_TYPE_UNDER_DOWN:
                self = .underDown
            case GTK_STACK_TRANSITION_TYPE_UNDER_LEFT:
                self = .underLeft
            case GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT:
                self = .underRight
            case GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN:
                self = .overUpDown
            case GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP:
                self = .overDownUp
            case GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT:
                self = .overLeftRight
            case GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT:
                self = .overRightLeft
            case GTK_STACK_TRANSITION_TYPE_ROTATE_LEFT:
                self = .rotateLeft
            case GTK_STACK_TRANSITION_TYPE_ROTATE_RIGHT:
                self = .rotateRight
            case GTK_STACK_TRANSITION_TYPE_ROTATE_LEFT_RIGHT:
                self = .rotateLeftRight
            default:
                fatalError("Unsupported GtkStackTransitionType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkStackTransitionType {
        switch self {
            case .none:
                return GTK_STACK_TRANSITION_TYPE_NONE
            case .crossfade:
                return GTK_STACK_TRANSITION_TYPE_CROSSFADE
            case .slideRight:
                return GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT
            case .slideLeft:
                return GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT
            case .slideUp:
                return GTK_STACK_TRANSITION_TYPE_SLIDE_UP
            case .slideDown:
                return GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN
            case .slideLeftRight:
                return GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT
            case .slideUpDown:
                return GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN
            case .overUp:
                return GTK_STACK_TRANSITION_TYPE_OVER_UP
            case .overDown:
                return GTK_STACK_TRANSITION_TYPE_OVER_DOWN
            case .overLeft:
                return GTK_STACK_TRANSITION_TYPE_OVER_LEFT
            case .overRight:
                return GTK_STACK_TRANSITION_TYPE_OVER_RIGHT
            case .underUp:
                return GTK_STACK_TRANSITION_TYPE_UNDER_UP
            case .underDown:
                return GTK_STACK_TRANSITION_TYPE_UNDER_DOWN
            case .underLeft:
                return GTK_STACK_TRANSITION_TYPE_UNDER_LEFT
            case .underRight:
                return GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT
            case .overUpDown:
                return GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN
            case .overDownUp:
                return GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP
            case .overLeftRight:
                return GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT
            case .overRightLeft:
                return GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT
            case .rotateLeft:
                return GTK_STACK_TRANSITION_TYPE_ROTATE_LEFT
            case .rotateRight:
                return GTK_STACK_TRANSITION_TYPE_ROTATE_RIGHT
            case .rotateLeftRight:
                return GTK_STACK_TRANSITION_TYPE_ROTATE_LEFT_RIGHT
        }
    }
}
