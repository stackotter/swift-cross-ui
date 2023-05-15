import CGtk

/// These enumeration values describe the possible transitions between pages in a `GtkStack` widget.
///
/// New values may be added to this enumeration over time.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.StackTransitionType.html)
public enum StackTransitionType {
    /// No transition.
    case none
    /// A cross-fade.
    case crossfade
    /// Slide from left to right.
    case slideRight
    /// Slide from right to left.
    case slideLeft
    /// Slide from bottom up.
    case slideUp
    /// Slide from top down.
    case slideDown
    /// Slide from left or right according to the children order.
    case slideLeftRight
    /// Slide from top down or bottom up according to the order.
    case slideUpDown
    /// Cover the old page by sliding up. Since 3.12
    case overUp
    /// Cover the old page by sliding down. Since: 3.12
    case overDown
    /// Cover the old page by sliding to the left. Since: 3.12
    case overLeft
    /// Cover the old page by sliding to the right. Since: 3.12
    case overRight
    /// Uncover the new page by sliding up. Since 3.12
    case underUp
    /// Uncover the new page by sliding down. Since: 3.12
    case underDown
    /// Uncover the new page by sliding to the left. Since: 3.12
    case underLeft
    /// Uncover the new page by sliding to the right. Since: 3.12
    case underRight
    /// Cover the old page sliding up or uncover the new page sliding down, according to order. Since: 3.12
    case overUpDown
    /// Cover the old page sliding down or uncover the new page sliding up, according to order. Since: 3.14
    case overDownUp
    /// Cover the old page sliding left or uncover the new page sliding right, according to order. Since: 3.14
    case overLeftRight
    /// Cover the old page sliding right or uncover the new page sliding left, according to order. Since: 3.14
    case overRightLeft

    func toGtkStackTransitionType() -> GtkStackTransitionType {
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
        }
    }
}

extension GtkStackTransitionType {
    func toStackTransitionType() -> StackTransitionType {
        switch self {
            case GTK_STACK_TRANSITION_TYPE_NONE:
                return StackTransitionType.none
            case GTK_STACK_TRANSITION_TYPE_CROSSFADE:
                return .crossfade
            case GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT:
                return .slideRight
            case GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT:
                return .slideLeft
            case GTK_STACK_TRANSITION_TYPE_SLIDE_UP:
                return .slideUp
            case GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN:
                return .slideDown
            case GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT:
                return .slideLeftRight
            case GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN:
                return .slideUpDown
            case GTK_STACK_TRANSITION_TYPE_OVER_UP:
                return .overUp
            case GTK_STACK_TRANSITION_TYPE_OVER_DOWN:
                return .overDown
            case GTK_STACK_TRANSITION_TYPE_OVER_LEFT:
                return .overLeft
            case GTK_STACK_TRANSITION_TYPE_OVER_RIGHT:
                return .overRight
            case GTK_STACK_TRANSITION_TYPE_UNDER_UP:
                return .underUp
            case GTK_STACK_TRANSITION_TYPE_UNDER_DOWN:
                return .underDown
            case GTK_STACK_TRANSITION_TYPE_UNDER_LEFT:
                return .underLeft
            case GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT:
                return .underRight
            case GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN:
                return .overUpDown
            case GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP:
                return .overDownUp
            case GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT:
                return .overLeftRight
            case GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT:
                return .overRightLeft
            default:
                fatalError("Unsupported GtkStackTransitionType enum value: \(self.rawValue)")
        }
    }
}
