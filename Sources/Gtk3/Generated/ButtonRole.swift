import CGtk3

/// The role specifies the desired appearance of a #GtkModelButton.
public enum ButtonRole: GValueRepresentableEnum {
    public typealias GtkEnum = GtkButtonRole

    /// A plain button
    case normal
    /// A check button
    case check
    /// A radio button
    case radio

    public static var type: GType {
        gtk_button_role_get_type()
    }

    public init(from gtkEnum: GtkButtonRole) {
        switch gtkEnum {
            case GTK_BUTTON_ROLE_NORMAL:
                self = .normal
            case GTK_BUTTON_ROLE_CHECK:
                self = .check
            case GTK_BUTTON_ROLE_RADIO:
                self = .radio
            default:
                fatalError("Unsupported GtkButtonRole enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkButtonRole {
        switch self {
            case .normal:
                return GTK_BUTTON_ROLE_NORMAL
            case .check:
                return GTK_BUTTON_ROLE_CHECK
            case .radio:
                return GTK_BUTTON_ROLE_RADIO
        }
    }
}
