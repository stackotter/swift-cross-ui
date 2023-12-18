import CGtk

/// These identify the various errors that can occur while calling
/// `GtkFileChooser` functions.
public enum FileChooserError: GValueRepresentableEnum {
    public typealias GtkEnum = GtkFileChooserError

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

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkFileChooserError) {
        switch gtkEnum {
            case GTK_FILE_CHOOSER_ERROR_NONEXISTENT:
                self = .nonexistent
            case GTK_FILE_CHOOSER_ERROR_BAD_FILENAME:
                self = .badFilename
            case GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS:
                self = .alreadyExists
            case GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME:
                self = .incompleteHostname
            default:
                fatalError("Unsupported GtkFileChooserError enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkFileChooserError {
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
