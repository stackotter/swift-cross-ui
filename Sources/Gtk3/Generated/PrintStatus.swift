import CGtk3

/// The status gives a rough indication of the completion of a running
/// print operation.
public enum PrintStatus: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPrintStatus

    /// The printing has not started yet; this
    /// status is set initially, and while the print dialog is shown.
    case initial
    /// This status is set while the begin-print
    /// signal is emitted and during pagination.
    case preparing
    /// This status is set while the
    /// pages are being rendered.
    case generatingData
    /// The print job is being sent off to the
    /// printer.
    case sendingData
    /// The print job has been sent to the printer,
    /// but is not printed for some reason, e.g. the printer may be stopped.
    case pending
    /// Some problem has occurred during
    /// printing, e.g. a paper jam.
    case pendingIssue
    /// The printer is processing the print job.
    case printing
    /// The printing has been completed successfully.
    case finished
    /// The printing has been aborted.
    case finishedAborted

    public static var type: GType {
        gtk_print_status_get_type()
    }

    public init(from gtkEnum: GtkPrintStatus) {
        switch gtkEnum {
            case GTK_PRINT_STATUS_INITIAL:
                self = .initial
            case GTK_PRINT_STATUS_PREPARING:
                self = .preparing
            case GTK_PRINT_STATUS_GENERATING_DATA:
                self = .generatingData
            case GTK_PRINT_STATUS_SENDING_DATA:
                self = .sendingData
            case GTK_PRINT_STATUS_PENDING:
                self = .pending
            case GTK_PRINT_STATUS_PENDING_ISSUE:
                self = .pendingIssue
            case GTK_PRINT_STATUS_PRINTING:
                self = .printing
            case GTK_PRINT_STATUS_FINISHED:
                self = .finished
            case GTK_PRINT_STATUS_FINISHED_ABORTED:
                self = .finishedAborted
            default:
                fatalError("Unsupported GtkPrintStatus enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPrintStatus {
        switch self {
            case .initial:
                return GTK_PRINT_STATUS_INITIAL
            case .preparing:
                return GTK_PRINT_STATUS_PREPARING
            case .generatingData:
                return GTK_PRINT_STATUS_GENERATING_DATA
            case .sendingData:
                return GTK_PRINT_STATUS_SENDING_DATA
            case .pending:
                return GTK_PRINT_STATUS_PENDING
            case .pendingIssue:
                return GTK_PRINT_STATUS_PENDING_ISSUE
            case .printing:
                return GTK_PRINT_STATUS_PRINTING
            case .finished:
                return GTK_PRINT_STATUS_FINISHED
            case .finishedAborted:
                return GTK_PRINT_STATUS_FINISHED_ABORTED
        }
    }
}
