import CGtk

/// Reading directions for text.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.TextDirection.html)
public enum TextDirection {
    /// No direction.
    case none
    /// Left to right text direction.
    case leftToRight
    /// Right to left text direction.
    case rightToLeft

    func toGtkTextDirection() -> GtkTextDirection {
        switch self {
            case .none:
                return GTK_TEXT_DIR_NONE
            case .leftToRight:
                return GTK_TEXT_DIR_LTR
            case .rightToLeft:
                return GTK_TEXT_DIR_RTL
        }
    }
}

extension GtkTextDirection {
    func toTextDirection() -> TextDirection {
        switch self {
            case GTK_TEXT_DIR_NONE:
                return TextDirection.none
            case GTK_TEXT_DIR_LTR:
                return .leftToRight
            case GTK_TEXT_DIR_RTL:
                return .rightToLeft
            default:
                fatalError("Unsupported GtkTextDirection enum value: \(self.rawValue)")
        }
    }
}
