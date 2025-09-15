import CGtk

/// Error codes that identify various errors that can occur while
/// using the GTK printing support.
public enum PrintError: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPrintError

    /// An unspecified error occurred.
    case general
    /// An internal error occurred.
    case internalError
    /// A memory allocation failed.
    case nomem
    /// An error occurred while loading a page setup
    /// or paper size from a key file.
    case invalidFile

    public static var type: GType {
        gtk_print_error_get_type()
    }

    public init(from gtkEnum: GtkPrintError) {
        switch gtkEnum {
            case GTK_PRINT_ERROR_GENERAL:
                self = .general
            case GTK_PRINT_ERROR_INTERNAL_ERROR:
                self = .internalError
            case GTK_PRINT_ERROR_NOMEM:
                self = .nomem
            case GTK_PRINT_ERROR_INVALID_FILE:
                self = .invalidFile
            default:
                fatalError("Unsupported GtkPrintError enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPrintError {
        switch self {
            case .general:
                return GTK_PRINT_ERROR_GENERAL
            case .internalError:
                return GTK_PRINT_ERROR_INTERNAL_ERROR
            case .nomem:
                return GTK_PRINT_ERROR_NOMEM
            case .invalidFile:
                return GTK_PRINT_ERROR_INVALID_FILE
        }
    }
}
