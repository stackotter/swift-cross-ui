import CGtk

/// Error codes that identify various errors that can occur while
/// using the GTK printing support.
public enum PrintError {
    /// An unspecified error occurred.
    case general
    /// An internal error occurred.
    case internalError
    /// A memory allocation failed.
    case nomem
    /// An error occurred while loading a page setup
    /// or paper size from a key file.
    case invalidFile

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPrintError() -> GtkPrintError {
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

extension GtkPrintError {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPrintError() -> PrintError {
        switch self {
            case GTK_PRINT_ERROR_GENERAL:
                return .general
            case GTK_PRINT_ERROR_INTERNAL_ERROR:
                return .internalError
            case GTK_PRINT_ERROR_NOMEM:
                return .nomem
            case GTK_PRINT_ERROR_INVALID_FILE:
                return .invalidFile
            default:
                fatalError("Unsupported GtkPrintError enum value: \(self.rawValue)")
        }
    }
}
