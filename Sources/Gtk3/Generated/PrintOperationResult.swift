import CGtk3

/// A value of this type is returned by gtk_print_operation_run().
public enum PrintOperationResult: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPrintOperationResult

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

    public static var type: GType {
        gtk_print_operation_result_get_type()
    }

    public init(from gtkEnum: GtkPrintOperationResult) {
        switch gtkEnum {
            case GTK_PRINT_OPERATION_RESULT_ERROR:
                self = .error
            case GTK_PRINT_OPERATION_RESULT_APPLY:
                self = .apply
            case GTK_PRINT_OPERATION_RESULT_CANCEL:
                self = .cancel
            case GTK_PRINT_OPERATION_RESULT_IN_PROGRESS:
                self = .inProgress
            default:
                fatalError("Unsupported GtkPrintOperationResult enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPrintOperationResult {
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
