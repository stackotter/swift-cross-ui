import CGtk

/// Reading directions for text.
public enum TextDirection: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTextDirection

    /// No direction.
    case none
    /// Left to right text direction.
    case ltr
    /// Right to left text direction.
    case rtl

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkTextDirection) {
        switch gtkEnum {
            case GTK_TEXT_DIR_NONE:
                self = .none
            case GTK_TEXT_DIR_LTR:
                self = .ltr
            case GTK_TEXT_DIR_RTL:
                self = .rtl
            default:
                fatalError("Unsupported GtkTextDirection enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkTextDirection {
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
