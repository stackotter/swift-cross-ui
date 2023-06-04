import CGtk

/// See also gtk_print_job_set_page_set().
public enum PageSet {
    /// All pages.
    case all
    /// Even pages.
    case even
    /// Odd pages.
    case odd

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPageSet() -> GtkPageSet {
        switch self {
            case .all:
                return GTK_PAGE_SET_ALL
            case .even:
                return GTK_PAGE_SET_EVEN
            case .odd:
                return GTK_PAGE_SET_ODD
        }
    }
}

extension GtkPageSet {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPageSet() -> PageSet {
        switch self {
            case GTK_PAGE_SET_ALL:
                return .all
            case GTK_PAGE_SET_EVEN:
                return .even
            case GTK_PAGE_SET_ODD:
                return .odd
            default:
                fatalError("Unsupported GtkPageSet enum value: \(self.rawValue)")
        }
    }
}
