import CGtk

/// Describes changes in a filter in more detail and allows objects
/// using the filter to optimize refiltering items.
///
/// If you are writing an implementation and are not sure which
/// value to pass, %GTK_FILTER_CHANGE_DIFFERENT is always a correct
/// choice.
public enum FilterChange {
    /// The filter change cannot be
    /// described with any of the other enumeration values.
    case different
    /// The filter is less strict than
    /// it was before: All items that it used to return %TRUE for
    /// still return %TRUE, others now may, too.
    case lessStrict
    /// The filter is more strict than
    /// it was before: All items that it used to return %FALSE for
    /// still return %FALSE, others now may, too.
    case moreStrict

    /// Converts the value to its corresponding Gtk representation.
    func toGtkFilterChange() -> GtkFilterChange {
        switch self {
            case .different:
                return GTK_FILTER_CHANGE_DIFFERENT
            case .lessStrict:
                return GTK_FILTER_CHANGE_LESS_STRICT
            case .moreStrict:
                return GTK_FILTER_CHANGE_MORE_STRICT
        }
    }
}

extension GtkFilterChange {
    /// Converts a Gtk value to its corresponding swift representation.
    func toFilterChange() -> FilterChange {
        switch self {
            case GTK_FILTER_CHANGE_DIFFERENT:
                return .different
            case GTK_FILTER_CHANGE_LESS_STRICT:
                return .lessStrict
            case GTK_FILTER_CHANGE_MORE_STRICT:
                return .moreStrict
            default:
                fatalError("Unsupported GtkFilterChange enum value: \(self.rawValue)")
        }
    }
}
