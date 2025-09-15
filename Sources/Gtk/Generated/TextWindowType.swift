import CGtk

/// Used to reference the parts of `GtkTextView`.
public enum TextWindowType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTextWindowType

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

    public static var type: GType {
        gtk_text_window_type_get_type()
    }

    public init(from gtkEnum: GtkTextWindowType) {
        switch gtkEnum {
            case GTK_TEXT_WINDOW_WIDGET:
                self = .widget
            case GTK_TEXT_WINDOW_TEXT:
                self = .text
            case GTK_TEXT_WINDOW_LEFT:
                self = .left
            case GTK_TEXT_WINDOW_RIGHT:
                self = .right
            case GTK_TEXT_WINDOW_TOP:
                self = .top
            case GTK_TEXT_WINDOW_BOTTOM:
                self = .bottom
            default:
                fatalError("Unsupported GtkTextWindowType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkTextWindowType {
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
