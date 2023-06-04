import CGtk

/// Describes the type of order that a `GtkSorter` may produce.
public enum SorterOrder {
    /// A partial order. Any `GtkOrdering` is possible.
    case partial
    /// No order, all elements are considered equal.
    /// gtk_sorter_compare() will only return %GTK_ORDERING_EQUAL.
    case none
    /// A total order. gtk_sorter_compare() will only
    /// return %GTK_ORDERING_EQUAL if an item is compared with itself. Two
    /// different items will never cause this value to be returned.
    case total

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSorterOrder() -> GtkSorterOrder {
        switch self {
            case .partial:
                return GTK_SORTER_ORDER_PARTIAL
            case .none:
                return GTK_SORTER_ORDER_NONE
            case .total:
                return GTK_SORTER_ORDER_TOTAL
        }
    }
}

extension GtkSorterOrder {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSorterOrder() -> SorterOrder {
        switch self {
            case GTK_SORTER_ORDER_PARTIAL:
                return .partial
            case GTK_SORTER_ORDER_NONE:
                return .none
            case GTK_SORTER_ORDER_TOTAL:
                return .total
            default:
                fatalError("Unsupported GtkSorterOrder enum value: \(self.rawValue)")
        }
    }
}
