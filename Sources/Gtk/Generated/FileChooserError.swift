import CGtk

/// These identify the various errors that can occur while calling
/// `GtkFileChooser` functions.
public enum FileChooserError {
    /// Indicates that a file does not exist.
    case nonexistent
    /// Indicates a malformed filename.
    case badFilename
    /// Indicates a duplicate path (e.g. when
    /// adding a bookmark).
    case alreadyExists
    /// Indicates an incomplete hostname
    /// (e.g. "http://foo" without a slash after that).
    case incompleteHostname

    /// Converts the value to its corresponding Gtk representation.
    func toGtkFileChooserError() -> GtkFileChooserError {
        switch self {
            case .nonexistent:
                return GTK_FILE_CHOOSER_ERROR_NONEXISTENT
            case .badFilename:
                return GTK_FILE_CHOOSER_ERROR_BAD_FILENAME
            case .alreadyExists:
                return GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS
            case .incompleteHostname:
                return GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME
        }
    }
}

extension GtkFileChooserError {
    /// Converts a Gtk value to its corresponding swift representation.
    func toFileChooserError() -> FileChooserError {
        switch self {
            case GTK_FILE_CHOOSER_ERROR_NONEXISTENT:
                return .nonexistent
            case GTK_FILE_CHOOSER_ERROR_BAD_FILENAME:
                return .badFilename
            case GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS:
                return .alreadyExists
            case GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME:
                return .incompleteHostname
            default:
                fatalError("Unsupported GtkFileChooserError enum value: \(self.rawValue)")
        }
    }
}
