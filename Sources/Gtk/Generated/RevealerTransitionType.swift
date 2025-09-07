import CGtk

/// These enumeration values describe the possible transitions
/// when the child of a `GtkRevealer` widget is shown or hidden.
public enum RevealerTransitionType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkRevealerTransitionType

    /// No transition
    case none
    /// Fade in
    case crossfade
    /// Slide in from the left
    case slideRight
    /// Slide in from the right
    case slideLeft
    /// Slide in from the bottom
    case slideUp
    /// Slide in from the top
    case slideDown
    /// Floop in from the left
    case swingRight
    /// Floop in from the right
    case swingLeft
    /// Floop in from the bottom
    case swingUp
    /// Floop in from the top
    case swingDown

    public static var type: GType {
        gtk_revealer_transition_type_get_type()
    }

    public init(from gtkEnum: GtkRevealerTransitionType) {
        switch gtkEnum {
            case GTK_REVEALER_TRANSITION_TYPE_NONE:
                self = .none
            case GTK_REVEALER_TRANSITION_TYPE_CROSSFADE:
                self = .crossfade
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT:
                self = .slideRight
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT:
                self = .slideLeft
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP:
                self = .slideUp
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN:
                self = .slideDown
            case GTK_REVEALER_TRANSITION_TYPE_SWING_RIGHT:
                self = .swingRight
            case GTK_REVEALER_TRANSITION_TYPE_SWING_LEFT:
                self = .swingLeft
            case GTK_REVEALER_TRANSITION_TYPE_SWING_UP:
                self = .swingUp
            case GTK_REVEALER_TRANSITION_TYPE_SWING_DOWN:
                self = .swingDown
            default:
                fatalError("Unsupported GtkRevealerTransitionType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkRevealerTransitionType {
        switch self {
            case .none:
                return GTK_REVEALER_TRANSITION_TYPE_NONE
            case .crossfade:
                return GTK_REVEALER_TRANSITION_TYPE_CROSSFADE
            case .slideRight:
                return GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT
            case .slideLeft:
                return GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT
            case .slideUp:
                return GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP
            case .slideDown:
                return GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN
            case .swingRight:
                return GTK_REVEALER_TRANSITION_TYPE_SWING_RIGHT
            case .swingLeft:
                return GTK_REVEALER_TRANSITION_TYPE_SWING_LEFT
            case .swingUp:
                return GTK_REVEALER_TRANSITION_TYPE_SWING_UP
            case .swingDown:
                return GTK_REVEALER_TRANSITION_TYPE_SWING_DOWN
        }
    }
}
