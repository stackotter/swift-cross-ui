import CGtk

/// Describes the known strictness of a filter.
///
/// Note that for filters where the strictness is not known,
/// %GTK_FILTER_MATCH_SOME is always an acceptable value,
/// even if a filter does match all or no items.
public enum FilterMatch {
    /// The filter matches some items,
    /// gtk_filter_match() may return %TRUE or %FALSE
    case some
    /// The filter does not match any item,
    /// gtk_filter_match() will always return %FALSE.
    case none
    /// The filter matches all items,
    /// gtk_filter_match() will alays return %TRUE.
    case all

    /// Converts the value to its corresponding Gtk representation.
    func toGtkFilterMatch() -> GtkFilterMatch {
        switch self {
            case .some:
                return GTK_FILTER_MATCH_SOME
            case .none:
                return GTK_FILTER_MATCH_NONE
            case .all:
                return GTK_FILTER_MATCH_ALL
        }
    }
}

extension GtkFilterMatch {
    /// Converts a Gtk value to its corresponding swift representation.
    func toFilterMatch() -> FilterMatch {
        switch self {
            case GTK_FILTER_MATCH_SOME:
                return .some
            case GTK_FILTER_MATCH_NONE:
                return .none
            case GTK_FILTER_MATCH_ALL:
                return .all
            default:
                fatalError("Unsupported GtkFilterMatch enum value: \(self.rawValue)")
        }
    }
}
