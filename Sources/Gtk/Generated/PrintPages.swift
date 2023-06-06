import CGtk

/// See also gtk_print_job_set_pages()
public enum PrintPages: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPrintPages

    /// All pages.
    case all
    /// Current page.
    case current
    /// Range of pages.
    case ranges
    /// Selected pages.
    case selection

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkPrintPages) {
        switch gtkEnum {
            case GTK_PRINT_PAGES_ALL:
                self = .all
            case GTK_PRINT_PAGES_CURRENT:
                self = .current
            case GTK_PRINT_PAGES_RANGES:
                self = .ranges
            case GTK_PRINT_PAGES_SELECTION:
                self = .selection
            default:
                fatalError("Unsupported GtkPrintPages enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkPrintPages {
        switch self {
            case .all:
                return GTK_PRINT_PAGES_ALL
            case .current:
                return GTK_PRINT_PAGES_CURRENT
            case .ranges:
                return GTK_PRINT_PAGES_RANGES
            case .selection:
                return GTK_PRINT_PAGES_SELECTION
        }
    }
}
