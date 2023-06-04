import CGtk

/// The possible values for the %GTK_ACCESSIBLE_PROPERTY_SORT
/// accessible property.
public enum AccessibleSort {
    /// There is no defined sort applied to the column.
    case none
    /// Items are sorted in ascending order by this column.
    case ascending
    /// Items are sorted in descending order by this column.
    case descending
    /// A sort algorithm other than ascending or
    /// descending has been applied.
    case other

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessibleSort() -> GtkAccessibleSort {
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

extension GtkAccessibleSort {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessibleSort() -> AccessibleSort {
        switch self {
            case GTK_ACCESSIBLE_SORT_NONE:
                return .none
            case GTK_ACCESSIBLE_SORT_ASCENDING:
                return .ascending
            case GTK_ACCESSIBLE_SORT_DESCENDING:
                return .descending
            case GTK_ACCESSIBLE_SORT_OTHER:
                return .other
            default:
                fatalError("Unsupported GtkAccessibleSort enum value: \(self.rawValue)")
        }
    }
}
