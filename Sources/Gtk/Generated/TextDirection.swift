import CGtk

/// Reading directions for text.
public enum TextDirection {
    /// No direction.
    case none
    /// Left to right text direction.
    case ltr
    /// Right to left text direction.
    case rtl

    /// Converts the value to its corresponding Gtk representation.
    func toGtkTextDirection() -> GtkTextDirection {
        switch self {
            case .none:
                return GTK_TEXT_DIR_NONE
            case .ltr:
                return GTK_TEXT_DIR_LTR
            case .rtl:
                return GTK_TEXT_DIR_RTL
        }
    }
}

extension GtkTextDirection {
    /// Converts a Gtk value to its corresponding swift representation.
    func toTextDirection() -> TextDirection {
        switch self {
            case GTK_TEXT_DIR_NONE:
                return .none
            case GTK_TEXT_DIR_LTR:
                return .ltr
            case GTK_TEXT_DIR_RTL:
                return .rtl
            default:
                fatalError("Unsupported GtkTextDirection enum value: \(self.rawValue)")
        }
    }
}
