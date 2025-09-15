import CGtk3

/// Prebuilt sets of buttons for the dialog. If
/// none of these choices are appropriate, simply use %GTK_BUTTONS_NONE
/// then call gtk_dialog_add_buttons().
///
/// > Please note that %GTK_BUTTONS_OK, %GTK_BUTTONS_YES_NO
/// > and %GTK_BUTTONS_OK_CANCEL are discouraged by the
/// > [GNOME Human Interface Guidelines](http://library.gnome.org/devel/hig-book/stable/).
public enum ButtonsType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkButtonsType

    /// No buttons at all
    case none
    /// An OK button
    case ok
    /// A Close button
    case close
    /// A Cancel button
    case cancel
    /// Yes and No buttons
    case yesNo
    /// OK and Cancel buttons
    case okCancel

    public static var type: GType {
        gtk_buttons_type_get_type()
    }

    public init(from gtkEnum: GtkButtonsType) {
        switch gtkEnum {
            case GTK_BUTTONS_NONE:
                self = .none
            case GTK_BUTTONS_OK:
                self = .ok
            case GTK_BUTTONS_CLOSE:
                self = .close
            case GTK_BUTTONS_CANCEL:
                self = .cancel
            case GTK_BUTTONS_YES_NO:
                self = .yesNo
            case GTK_BUTTONS_OK_CANCEL:
                self = .okCancel
            default:
                fatalError("Unsupported GtkButtonsType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkButtonsType {
        switch self {
            case .none:
                return GTK_BUTTONS_NONE
            case .ok:
                return GTK_BUTTONS_OK
            case .close:
                return GTK_BUTTONS_CLOSE
            case .cancel:
                return GTK_BUTTONS_CANCEL
            case .yesNo:
                return GTK_BUTTONS_YES_NO
            case .okCancel:
                return GTK_BUTTONS_OK_CANCEL
        }
    }
}
