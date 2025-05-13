import CGtk

/// Describes changes in a filter in more detail and allows objects
/// using the filter to optimize refiltering items.
///
/// If you are writing an implementation and are not sure which
/// value to pass, `GTK_FILTER_CHANGE_DIFFERENT` is always a correct
/// choice.
public enum FilterChange: GValueRepresentableEnum {
    public typealias GtkEnum = GtkFilterChange

    /// The filter change cannot be
    /// described with any of the other enumeration values
    case different
    /// The filter is less strict than
    /// it was before: All items that it used to return true
    /// still return true, others now may, too.
    case lessStrict
    /// The filter is more strict than
    /// it was before: All items that it used to return false
    /// still return false, others now may, too.
    case moreStrict

    public static var type: GType {
        gtk_filter_change_get_type()
    }

    public init(from gtkEnum: GtkFilterChange) {
        switch gtkEnum {
            case GTK_FILTER_CHANGE_DIFFERENT:
                self = .different
            case GTK_FILTER_CHANGE_LESS_STRICT:
                self = .lessStrict
            case GTK_FILTER_CHANGE_MORE_STRICT:
                self = .moreStrict
            default:
                fatalError("Unsupported GtkFilterChange enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkFilterChange {
        switch self {
            case .different:
                return GTK_FILTER_CHANGE_DIFFERENT
            case .lessStrict:
                return GTK_FILTER_CHANGE_LESS_STRICT
            case .moreStrict:
                return GTK_FILTER_CHANGE_MORE_STRICT
        }
    }
}
