import CGtk

/// Prebuilt sets of buttons for the dialog. If none of these choices are appropriate, simply use
/// `GTK_BUTTONS_NONE` then call `gtk_dialog_add_buttons()`.
///
/// Please note that GTK_BUTTONS_OK, GTK_BUTTONS_YES_NO and GTK_BUTTONS_OK_CANCEL are discouraged by
/// the [GNOME Human Interface Guidelines](http://library.gnome.org/devel/hig-book/stable/).
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ButtonsType.html)
public enum ButtonsType {
    /// No buttons at all.
    case none
    /// An OK button.
    case ok
    /// A Close button.
    case close
    /// A Cancel button.
    case cancel
    /// Yes and No buttons.
    case yesAndNo
    /// OK and Cancel buttons.
    case okAndCancel

    func toGtkButtonsType() -> GtkButtonsType {
        switch self {
            case .none:
                return GTK_BUTTONS_NONE
            case .ok:
                return GTK_BUTTONS_OK
            case .close:
                return GTK_BUTTONS_CLOSE
            case .cancel:
                return GTK_BUTTONS_CANCEL
            case .yesAndNo:
                return GTK_BUTTONS_YES_NO
            case .okAndCancel:
                return GTK_BUTTONS_OK_CANCEL
        }
    }
}

extension GtkButtonsType {
    func toButtonsType() -> ButtonsType {
        switch self {
            case GTK_BUTTONS_NONE:
                return ButtonsType.none
            case GTK_BUTTONS_OK:
                return .ok
            case GTK_BUTTONS_CLOSE:
                return .close
            case GTK_BUTTONS_CANCEL:
                return .cancel
            case GTK_BUTTONS_YES_NO:
                return .yesAndNo
            case GTK_BUTTONS_OK_CANCEL:
                return .okAndCancel
            default:
                fatalError("Unsupported GtkButtonsType enum value: \(self.rawValue)")
        }
    }
}
