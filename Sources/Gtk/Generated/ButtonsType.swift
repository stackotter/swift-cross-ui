import CGtk

/// Prebuilt sets of buttons for `GtkDialog`.
///
/// If none of these choices are appropriate, simply use
/// %GTK_BUTTONS_NONE and call [method@Gtk.Dialog.add_buttons].
///
/// > Please note that %GTK_BUTTONS_OK, %GTK_BUTTONS_YES_NO
/// > and %GTK_BUTTONS_OK_CANCEL are discouraged by the
/// > [GNOME Human Interface Guidelines](http://library.gnome.org/devel/hig-book/stable/).
public enum ButtonsType {
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

    /// Converts the value to its corresponding Gtk representation.
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
            case .yesNo:
                return GTK_BUTTONS_YES_NO
            case .okCancel:
                return GTK_BUTTONS_OK_CANCEL
        }
    }
}

extension GtkButtonsType {
    /// Converts a Gtk value to its corresponding swift representation.
    func toButtonsType() -> ButtonsType {
        switch self {
            case GTK_BUTTONS_NONE:
                return .none
            case GTK_BUTTONS_OK:
                return .ok
            case GTK_BUTTONS_CLOSE:
                return .close
            case GTK_BUTTONS_CANCEL:
                return .cancel
            case GTK_BUTTONS_YES_NO:
                return .yesNo
            case GTK_BUTTONS_OK_CANCEL:
                return .okCancel
            default:
                fatalError("Unsupported GtkButtonsType enum value: \(self.rawValue)")
        }
    }
}
