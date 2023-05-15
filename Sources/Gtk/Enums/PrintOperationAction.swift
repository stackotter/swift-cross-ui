import CGtk

/// The action parameter to `gtk_print_operation_run()` determines what action the print operation should perform.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.PrintOperationAction.html)
public enum PrintOperationAction {
    /// Show the print dialog.
    case printDialog
    /// Start to print without showing the print dialog, based on the current print settings.
    case print
    /// Show the print preview.
    case preview
    /// Export to a file. This requires the export-filename property to be set.
    case export

    func toGtkPrintOperationAction() -> GtkPrintOperationAction {
        switch self {
            case .printDialog:
                return GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG
            case .print:
                return GTK_PRINT_OPERATION_ACTION_PRINT
            case .preview:
                return GTK_PRINT_OPERATION_ACTION_PREVIEW
            case .export:
                return GTK_PRINT_OPERATION_ACTION_EXPORT
        }
    }
}

extension GtkPrintOperationAction {
    func toPrintOperationAction() -> PrintOperationAction {
        switch self {
            case GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG:
                return .printDialog
            case GTK_PRINT_OPERATION_ACTION_PRINT:
                return .print
            case GTK_PRINT_OPERATION_ACTION_PREVIEW:
                return .preview
            case GTK_PRINT_OPERATION_ACTION_EXPORT:
                return .export
            default:
                fatalError("Unsupported GtkPrintOperationAction enum value: \(self.rawValue)")
        }
    }
}
