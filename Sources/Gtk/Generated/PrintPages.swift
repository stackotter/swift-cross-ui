import CGtk

/// See also gtk_print_job_set_pages()
public enum PrintPages {
    /// All pages.
    case all
    /// Current page.
    case current
    /// Range of pages.
    case ranges
    /// Selected pages.
    case selection

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPrintPages() -> GtkPrintPages {
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

extension GtkPrintPages {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPrintPages() -> PrintPages {
        switch self {
            case GTK_PRINT_PAGES_ALL:
                return .all
            case GTK_PRINT_PAGES_CURRENT:
                return .current
            case GTK_PRINT_PAGES_RANGES:
                return .ranges
            case GTK_PRINT_PAGES_SELECTION:
                return .selection
            default:
                fatalError("Unsupported GtkPrintPages enum value: \(self.rawValue)")
        }
    }
}
