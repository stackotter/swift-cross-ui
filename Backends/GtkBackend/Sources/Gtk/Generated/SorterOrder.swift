import CGtk

/// Describes the type of order that a `GtkSorter` may produce.
public enum SorterOrder: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSorterOrder

    /// A partial order. Any `GtkOrdering` is possible.
    case partial
    /// No order, all elements are considered equal.
    /// gtk_sorter_compare() will only return %GTK_ORDERING_EQUAL.
    case none
    /// A total order. gtk_sorter_compare() will only
    /// return %GTK_ORDERING_EQUAL if an item is compared with itself. Two
    /// different items will never cause this value to be returned.
    case total

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkSorterOrder) {
        switch gtkEnum {
            case GTK_SORTER_ORDER_PARTIAL:
                self = .partial
            case GTK_SORTER_ORDER_NONE:
                self = .none
            case GTK_SORTER_ORDER_TOTAL:
                self = .total
            default:
                fatalError("Unsupported GtkSorterOrder enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkSorterOrder {
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
