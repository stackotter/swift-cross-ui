import CGtk

/// Describes changes in a sorter in more detail and allows users
/// to optimize resorting.
public enum SorterChange {
    /// The sorter change cannot be described
    /// by any of the other enumeration values
    case different
    /// The sort order was inverted. Comparisons
    /// that returned %GTK_ORDERING_SMALLER now return %GTK_ORDERING_LARGER
    /// and vice versa. Other comparisons return the same values as before.
    case inverted
    /// The sorter is less strict: Comparisons
    /// may now return %GTK_ORDERING_EQUAL that did not do so before.
    case lessStrict
    /// The sorter is more strict: Comparisons
    /// that did return %GTK_ORDERING_EQUAL may not do so anymore.
    case moreStrict

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSorterChange() -> GtkSorterChange {
        switch self {
            case .different:
                return GTK_SORTER_CHANGE_DIFFERENT
            case .inverted:
                return GTK_SORTER_CHANGE_INVERTED
            case .lessStrict:
                return GTK_SORTER_CHANGE_LESS_STRICT
            case .moreStrict:
                return GTK_SORTER_CHANGE_MORE_STRICT
        }
    }
}

extension GtkSorterChange {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSorterChange() -> SorterChange {
        switch self {
            case GTK_SORTER_CHANGE_DIFFERENT:
                return .different
            case GTK_SORTER_CHANGE_INVERTED:
                return .inverted
            case GTK_SORTER_CHANGE_LESS_STRICT:
                return .lessStrict
            case GTK_SORTER_CHANGE_MORE_STRICT:
                return .moreStrict
            default:
                fatalError("Unsupported GtkSorterChange enum value: \(self.rawValue)")
        }
    }
}
