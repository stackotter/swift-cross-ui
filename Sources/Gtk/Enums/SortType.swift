import CGtk

/// Determines the direction of a sort.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.SortType.html)
public enum SortType {
    /// Sorting is in ascending order.
    case ascending
    /// Sorting is in descending order.
    case descending

    func toGtkSortType() -> GtkSortType {
        switch self {
            case .ascending:
                return GTK_SORT_ASCENDING
            case .descending:
                return GTK_SORT_DESCENDING
        }
    }
}

extension GtkSortType {
    func toSortType() -> SortType {
        switch self {
            case GTK_SORT_ASCENDING:
                return .ascending
            case GTK_SORT_DESCENDING:
                return .descending
            default:
                fatalError("Unsupported GtkSortType enum value: \(self.rawValue)")
        }
    }
}
