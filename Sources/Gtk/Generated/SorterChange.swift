import CGtk

/// Describes changes in a sorter in more detail and allows users
/// to optimize resorting.
public enum SorterChange: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSorterChange

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

    public static var type: GType {
        gtk_sorter_change_get_type()
    }

    public init(from gtkEnum: GtkSorterChange) {
        switch gtkEnum {
            case GTK_SORTER_CHANGE_DIFFERENT:
                self = .different
            case GTK_SORTER_CHANGE_INVERTED:
                self = .inverted
            case GTK_SORTER_CHANGE_LESS_STRICT:
                self = .lessStrict
            case GTK_SORTER_CHANGE_MORE_STRICT:
                self = .moreStrict
            default:
                fatalError("Unsupported GtkSorterChange enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkSorterChange {
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
