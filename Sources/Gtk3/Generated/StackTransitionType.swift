import CGtk3

/// These enumeration values describe the possible transitions
/// between pages in a #GtkStack widget.
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
        }
    }
}
