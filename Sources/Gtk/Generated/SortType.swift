import CGtk

/// Determines the direction of a sort.
public enum SortType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSortType

    /// Sorting is in ascending order.
    case ascending
    /// Sorting is in descending order.
    case descending

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkSortType) {
        switch gtkEnum {
            case GTK_SORT_ASCENDING:
                self = .ascending
            case GTK_SORT_DESCENDING:
                self = .descending
            default:
                fatalError("Unsupported GtkSortType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkSortType {
        switch self {
            case .ascending:
                return GTK_SORT_ASCENDING
            case .descending:
                return GTK_SORT_DESCENDING
        }
    }
}
