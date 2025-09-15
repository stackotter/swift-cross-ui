import CGtk3

/// Describes whether a #GtkFileChooser is being used to open existing files
/// or to save to a possibly new file.
public enum FileChooserAction: GValueRepresentableEnum {
    public typealias GtkEnum = GtkFileChooserAction

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
    /// Indicates a mode for creating a
    /// new folder.  The file chooser will let the user name an existing or
    /// new folder.
    case createFolder

    public static var type: GType {
        gtk_file_chooser_action_get_type()
    }

    public init(from gtkEnum: GtkFileChooserAction) {
        switch gtkEnum {
            case GTK_FILE_CHOOSER_ACTION_OPEN:
                self = .open
            case GTK_FILE_CHOOSER_ACTION_SAVE:
                self = .save
            case GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER:
                self = .selectFolder
            case GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER:
                self = .createFolder
            default:
                fatalError("Unsupported GtkFileChooserAction enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkFileChooserAction {
        switch self {
            case .open:
                return GTK_FILE_CHOOSER_ACTION_OPEN
            case .save:
                return GTK_FILE_CHOOSER_ACTION_SAVE
            case .selectFolder:
                return GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER
            case .createFolder:
                return GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER
        }
    }
}
