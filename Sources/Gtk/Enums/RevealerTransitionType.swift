import CGtk

/// These enumeration values describe the possible transitions when the child of a GtkRevealer widget is shown or hidden.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.RevealerTransitionType.html)
public enum RevealerTransitionType {
    /// No transition.
    case none
    /// Fade in.
    case crossFade
    /// Slide in from the left.
    case slideRight
    /// Slide in from the right.
    case slideLeft
    /// Slide in from the bottom.
    case slideUp
    /// Slide in from the top.
    case slideDown

    func toGtkRevealerTransitionType() -> GtkRevealerTransitionType {
        switch self {
            case .none:
                return GTK_REVEALER_TRANSITION_TYPE_NONE
            case .crossFade:
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

extension GtkRevealerTransitionType {
    func toRevealerTransitionType() -> RevealerTransitionType {
        switch self {
            case GTK_REVEALER_TRANSITION_TYPE_NONE:
                return RevealerTransitionType.none
            case GTK_REVEALER_TRANSITION_TYPE_CROSSFADE:
                return .crossFade
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT:
                return .slideRight
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT:
                return .slideLeft
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP:
                return .slideUp
            case GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN:
                return .slideDown
            default:
                fatalError("Unsupported GtkRevealerTransitionType enum value: \(self.rawValue)")
        }
    }
}
