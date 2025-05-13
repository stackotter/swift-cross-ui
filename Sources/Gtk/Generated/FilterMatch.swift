import CGtk

/// Describes the known strictness of a filter.
///
/// Note that for filters where the strictness is not known,
/// `GTK_FILTER_MATCH_SOME` is always an acceptable value,
/// even if a filter does match all or no items.
public enum FilterMatch: GValueRepresentableEnum {
    public typealias GtkEnum = GtkFilterMatch

    /// The filter matches some items,
    /// [method@Gtk.Filter.match] may return true or false
    case some
    /// The filter does not match any item,
    /// [method@Gtk.Filter.match] will always return false
    case none
    /// The filter matches all items,
    /// [method@Gtk.Filter.match] will alays return true
    case all

    public static var type: GType {
        gtk_filter_match_get_type()
    }

    public init(from gtkEnum: GtkFilterMatch) {
        switch gtkEnum {
            case GTK_FILTER_MATCH_SOME:
                self = .some
            case GTK_FILTER_MATCH_NONE:
                self = .none
            case GTK_FILTER_MATCH_ALL:
                self = .all
            default:
                fatalError("Unsupported GtkFilterMatch enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkFilterMatch {
        switch self {
            case .some:
                return GTK_FILTER_MATCH_SOME
            case .none:
                return GTK_FILTER_MATCH_NONE
            case .all:
                return GTK_FILTER_MATCH_ALL
        }
    }
}
