import CGtk3

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

    public static var type: GType {
    gtk_print_pages_get_type()
}

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