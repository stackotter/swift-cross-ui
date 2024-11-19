import CGtk3

/// Style for input method preedit. See also
/// #GtkSettings:gtk-im-preedit-style
public enum IMPreeditStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkIMPreeditStyle

    /// Deprecated
    case nothing
    /// Deprecated
    case callback
    /// Deprecated
    case none

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkIMPreeditStyle) {
        switch gtkEnum {
            case GTK_IM_PREEDIT_NOTHING:
                self = .nothing
            case GTK_IM_PREEDIT_CALLBACK:
                self = .callback
            case GTK_IM_PREEDIT_NONE:
                self = .none
            default:
                fatalError("Unsupported GtkIMPreeditStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkIMPreeditStyle {
        switch self {
            case .nothing:
                return GTK_IM_PREEDIT_NOTHING
            case .callback:
                return GTK_IM_PREEDIT_CALLBACK
            case .none:
                return GTK_IM_PREEDIT_NONE
        }
    }
}
