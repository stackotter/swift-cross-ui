import CGtk

/// These enumeration values describe the possible transitions
/// when the child of a `GtkRevealer` widget is shown or hidden.
public enum RevealerTransitionType {
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

    /// Converts the value to its corresponding Gtk representation.
    func toGtkRevealerTransitionType() -> GtkRevealerTransitionType {
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

extension GtkRevealerTransitionType {
    /// Converts a Gtk value to its corresponding swift representation.
    func toRevealerTransitionType() -> RevealerTransitionType {
        switch self {
            case GTK_REVEALER_TRANSITION_TYPE_NONE:
                return .none
            case GTK_REVEALER_TRANSITION_TYPE_CROSSFADE:
                return .crossfade
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT:
                return .slideRight
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT:
                return .slideLeft
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP:
                return .slideUp
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN:
                return .slideDown
            case GTK_REVEALER_TRANSITION_TYPE_SWING_RIGHT:
                return .swingRight
            case GTK_REVEALER_TRANSITION_TYPE_SWING_LEFT:
                return .swingLeft
            case GTK_REVEALER_TRANSITION_TYPE_SWING_UP:
                return .swingUp
            case GTK_REVEALER_TRANSITION_TYPE_SWING_DOWN:
                return .swingDown
            default:
                fatalError("Unsupported GtkRevealerTransitionType enum value: \(self.rawValue)")
        }
    }
}
