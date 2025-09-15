import CGtk3

/// Determines the direction of a sort.
public enum SortType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSortType

    /// Sorting is in ascending order.
    case ascending
    /// Sorting is in descending order.
    case descending

    public static var type: GType {
        gtk_sort_type_get_type()
    }

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

    public func toGtk() -> GtkSortType {
        switch self {
            case .ascending:
                return GTK_SORT_ASCENDING
            case .descending:
                return GTK_SORT_DESCENDING
        }
    }
}
