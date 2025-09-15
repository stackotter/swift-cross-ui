import CGtk3

/// These enumeration values describe the possible transitions
/// when the child of a #GtkRevealer widget is shown or hidden.
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
        }
    }
}
