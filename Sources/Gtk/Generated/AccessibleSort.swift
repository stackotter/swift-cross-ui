import CGtk

/// The possible values for the %GTK_ACCESSIBLE_PROPERTY_SORT
/// accessible property.
public enum AccessibleSort: GValueRepresentableEnum {
    public typealias GtkEnum = GtkAccessibleSort

    /// There is no defined sort applied to the column.
    case none
    /// Items are sorted in ascending order by this column.
    case ascending
    /// Items are sorted in descending order by this column.
    case descending
    /// A sort algorithm other than ascending or
    /// descending has been applied.
    case other

    public static var type: GType {
        gtk_accessible_sort_get_type()
    }

    public init(from gtkEnum: GtkAccessibleSort) {
        switch gtkEnum {
            case GTK_ACCESSIBLE_SORT_NONE:
                self = .none
            case GTK_ACCESSIBLE_SORT_ASCENDING:
                self = .ascending
            case GTK_ACCESSIBLE_SORT_DESCENDING:
                self = .descending
            case GTK_ACCESSIBLE_SORT_OTHER:
                self = .other
            default:
                fatalError("Unsupported GtkAccessibleSort enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkAccessibleSort {
        switch self {
            case .none:
                return GTK_ACCESSIBLE_SORT_NONE
            case .ascending:
                return GTK_ACCESSIBLE_SORT_ASCENDING
            case .descending:
                return GTK_ACCESSIBLE_SORT_DESCENDING
            case .other:
                return GTK_ACCESSIBLE_SORT_OTHER
        }
    }
}
