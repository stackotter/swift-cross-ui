import CGtk

/// The result of a print operation.
///
/// A value of this type is returned by [method@Gtk.PrintOperation.run].
public enum PrintOperationResult {
    /// An error has occurred.
    case error
    /// The print settings should be stored.
    case apply
    /// The print operation has been canceled,
    /// the print settings should not be stored.
    case cancel
    /// The print operation is not complete
    /// yet. This value will only be returned when running asynchronously.
    case inProgress

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPrintOperationResult() -> GtkPrintOperationResult {
        switch self {
            case .error:
                return GTK_PRINT_OPERATION_RESULT_ERROR
            case .apply:
                return GTK_PRINT_OPERATION_RESULT_APPLY
            case .cancel:
                return GTK_PRINT_OPERATION_RESULT_CANCEL
            case .inProgress:
                return GTK_PRINT_OPERATION_RESULT_IN_PROGRESS
        }
    }
}

extension GtkPrintOperationResult {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPrintOperationResult() -> PrintOperationResult {
        switch self {
            case GTK_PRINT_OPERATION_RESULT_ERROR:
                return .error
            case GTK_PRINT_OPERATION_RESULT_APPLY:
                return .apply
            case GTK_PRINT_OPERATION_RESULT_CANCEL:
                return .cancel
            case GTK_PRINT_OPERATION_RESULT_IN_PROGRESS:
                return .inProgress
            default:
                fatalError("Unsupported GtkPrintOperationResult enum value: \(self.rawValue)")
        }
    }
}
