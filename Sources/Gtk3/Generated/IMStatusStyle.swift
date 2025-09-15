import CGtk3

/// Style for input method status. See also
/// #GtkSettings:gtk-im-status-style
public enum IMStatusStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkIMStatusStyle

    /// Deprecated
case nothing
/// Deprecated
case callback
/// Deprecated
case none

    public static var type: GType {
    gtk_im_status_style_get_type()
}

    public init(from gtkEnum: GtkIMStatusStyle) {
        switch gtkEnum {
            case GTK_IM_STATUS_NOTHING:
    self = .nothing
case GTK_IM_STATUS_CALLBACK:
    self = .callback
case GTK_IM_STATUS_NONE:
    self = .none
            default:
                fatalError("Unsupported GtkIMStatusStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkIMStatusStyle {
        switch self {
            case .nothing:
    return GTK_IM_STATUS_NOTHING
case .callback:
    return GTK_IM_STATUS_CALLBACK
case .none:
    return GTK_IM_STATUS_NONE
        }
    }
}