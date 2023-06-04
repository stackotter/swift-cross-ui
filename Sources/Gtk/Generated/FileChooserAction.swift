import CGtk

/// Describes whether a `GtkFileChooser` is being used to open existing files
/// or to save to a possibly new file.
public enum FileChooserAction {
    /// Indicates open mode.  The file chooser
    /// will only let the user pick an existing file.
    case open
    /// Indicates save mode.  The file chooser
    /// will let the user pick an existing file, or type in a new
    /// filename.
    case save
    /// Indicates an Open mode for
    /// selecting folders.  The file chooser will let the user pick an
    /// existing folder.
    case selectFolder

    /// Converts the value to its corresponding Gtk representation.
    func toGtkFileChooserAction() -> GtkFileChooserAction {
        switch self {
            case .open:
                return GTK_FILE_CHOOSER_ACTION_OPEN
            case .save:
                return GTK_FILE_CHOOSER_ACTION_SAVE
            case .selectFolder:
                return GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER
        }
    }
}

extension GtkFileChooserAction {
    /// Converts a Gtk value to its corresponding swift representation.
    func toFileChooserAction() -> FileChooserAction {
        switch self {
            case GTK_FILE_CHOOSER_ACTION_OPEN:
                return .open
            case GTK_FILE_CHOOSER_ACTION_SAVE:
                return .save
            case GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER:
                return .selectFolder
            default:
                fatalError("Unsupported GtkFileChooserAction enum value: \(self.rawValue)")
        }
    }
}
