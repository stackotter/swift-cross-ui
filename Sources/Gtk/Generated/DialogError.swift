import CGtk

/// Error codes in the `GTK_DIALOG_ERROR` domain that can be returned
/// by async dialog functions.
public enum DialogError {
    /// Generic error condition for when
    /// an operation fails and no more specific code is applicable
    case failed
    /// The async function call was cancelled
    /// via its `GCancellable`
    case cancelled
    /// The operation was cancelled
    /// by the user (via a Cancel or Close button)
    case dismissed

    /// Converts the value to its corresponding Gtk representation.
    func toGtkDialogError() -> GtkDialogError {
        switch self {
            case .failed:
                return GTK_DIALOG_ERROR_FAILED
            case .cancelled:
                return GTK_DIALOG_ERROR_CANCELLED
            case .dismissed:
                return GTK_DIALOG_ERROR_DISMISSED
        }
    }
}

extension GtkDialogError {
    /// Converts a Gtk value to its corresponding swift representation.
    func toDialogError() -> DialogError {
        switch self {
            case GTK_DIALOG_ERROR_FAILED:
                return .failed
            case GTK_DIALOG_ERROR_CANCELLED:
                return .cancelled
            case GTK_DIALOG_ERROR_DISMISSED:
                return .dismissed
            default:
                fatalError("Unsupported GtkDialogError enum value: \(self.rawValue)")
        }
    }
}
