import CGtk

/// Determines what action the print operation should perform.
///
/// A parameter of this typs is passed to [method@Gtk.PrintOperation.run].
public enum PrintOperationAction: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPrintOperationAction

    /// Show the print dialog.
    case printDialog
    /// Start to print without showing
    /// the print dialog, based on the current print settings.
    case print
    /// Show the print preview.
    case preview
    /// Export to a file. This requires
    /// the export-filename property to be set.
    case export

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkPrintOperationAction) {
        switch gtkEnum {
            case GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG:
                self = .printDialog
            case GTK_PRINT_OPERATION_ACTION_PRINT:
                self = .print
            case GTK_PRINT_OPERATION_ACTION_PREVIEW:
                self = .preview
            case GTK_PRINT_OPERATION_ACTION_EXPORT:
                self = .export
            default:
                fatalError("Unsupported GtkPrintOperationAction enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkPrintOperationAction {
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
