import CGtk

/// Predefined values for use as response ids in `gtk_dialog_add_button()`. All predefined values
/// are negative; GTK+ leaves values of 0 or greater for application-defined response ids.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ResponseType.html)
public enum ResponseType {
    /// Returned if an action widget has no response id, or if the dialog gets programmatically
    /// hidden or destroyed.
    case none
    /// Generic response id, not used by GTK+ dialogs.
    case reject
    /// Generic response id, not used by GTK+ dialogs.
    case accept
    /// Returned if the dialog is deleted.
    case deleteEvent
    /// Returned by OK buttons in GTK+ dialogs.
    case ok
    /// Returned by Cancel buttons in GTK+ dialogs.
    case cancel
    /// Returned by Close buttons in GTK+ dialogs.
    case close
    /// Returned by Yes buttons in GTK+ dialogs.
    case yes
    /// Returned by No buttons in GTK+ dialogs.
    case no
    /// Returned by Apply buttons in GTK+ dialogs.
    case apply
    /// Returned by Help buttons in GTK+ dialogs.
    case help

    func toGtkResponseType() -> GtkResponseType {
        switch self {
            case .none:
                return GTK_RESPONSE_NONE
            case .reject:
                return GTK_RESPONSE_REJECT
            case .accept:
                return GTK_RESPONSE_ACCEPT
            case .deleteEvent:
                return GTK_RESPONSE_DELETE_EVENT
            case .ok:
                return GTK_RESPONSE_OK
            case .cancel:
                return GTK_RESPONSE_CANCEL
            case .close:
                return GTK_RESPONSE_CLOSE
            case .yes:
                return GTK_RESPONSE_YES
            case .no:
                return GTK_RESPONSE_NO
            case .apply:
                return GTK_RESPONSE_APPLY
            case .help:
                return GTK_RESPONSE_HELP
        }
    }
}

extension GtkResponseType {
    func toResponseType() -> ResponseType {
        switch self {
            case GTK_RESPONSE_NONE:
                return ResponseType.none
            case GTK_RESPONSE_REJECT:
                return .reject
            case GTK_RESPONSE_ACCEPT:
                return .accept
            case GTK_RESPONSE_DELETE_EVENT:
                return .deleteEvent
            case GTK_RESPONSE_OK:
                return .ok
            case GTK_RESPONSE_CANCEL:
                return .cancel
            case GTK_RESPONSE_CLOSE:
                return .close
            case GTK_RESPONSE_YES:
                return .yes
            case GTK_RESPONSE_NO:
                return .no
            case GTK_RESPONSE_APPLY:
                return .apply
            case GTK_RESPONSE_HELP:
                return .help
            default:
                fatalError("Unsupported GtkResponseType enum value: \(self.rawValue)")
        }
    }
}
