import CGtk

/// Used to reference the parts of `GtkTextView`.
public enum TextWindowType {
    /// Window that floats over scrolling areas.
    case widget
    /// Scrollable text window.
    case text
    /// Left side border window.
    case left
    /// Right side border window.
    case right
    /// Top border window.
    case top
    /// Bottom border window.
    case bottom

    /// Converts the value to its corresponding Gtk representation.
    func toGtkTextWindowType() -> GtkTextWindowType {
        switch self {
            case .widget:
                return GTK_TEXT_WINDOW_WIDGET
            case .text:
                return GTK_TEXT_WINDOW_TEXT
            case .left:
                return GTK_TEXT_WINDOW_LEFT
            case .right:
                return GTK_TEXT_WINDOW_RIGHT
            case .top:
                return GTK_TEXT_WINDOW_TOP
            case .bottom:
                return GTK_TEXT_WINDOW_BOTTOM
        }
    }
}

extension GtkTextWindowType {
    /// Converts a Gtk value to its corresponding swift representation.
    func toTextWindowType() -> TextWindowType {
        switch self {
            case GTK_TEXT_WINDOW_WIDGET:
                return .widget
            case GTK_TEXT_WINDOW_TEXT:
                return .text
            case GTK_TEXT_WINDOW_LEFT:
                return .left
            case GTK_TEXT_WINDOW_RIGHT:
                return .right
            case GTK_TEXT_WINDOW_TOP:
                return .top
            case GTK_TEXT_WINDOW_BOTTOM:
                return .bottom
            default:
                fatalError("Unsupported GtkTextWindowType enum value: \(self.rawValue)")
        }
    }
}
