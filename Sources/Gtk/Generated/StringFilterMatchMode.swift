import CGtk

/// Specifies how search strings are matched inside text.
public enum StringFilterMatchMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkStringFilterMatchMode

    /// The search string and
    /// text must match exactly
    case exact
    /// The search string
    /// must be contained as a substring inside the text
    case substring
    /// The text must begin
    /// with the search string
    case prefix

    public static var type: GType {
        gtk_string_filter_match_mode_get_type()
    }

    public init(from gtkEnum: GtkStringFilterMatchMode) {
        switch gtkEnum {
            case GTK_STRING_FILTER_MATCH_MODE_EXACT:
                self = .exact
            case GTK_STRING_FILTER_MATCH_MODE_SUBSTRING:
                self = .substring
            case GTK_STRING_FILTER_MATCH_MODE_PREFIX:
                self = .prefix
            default:
                fatalError("Unsupported GtkStringFilterMatchMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkStringFilterMatchMode {
        switch self {
            case .exact:
                return GTK_STRING_FILTER_MATCH_MODE_EXACT
            case .substring:
                return GTK_STRING_FILTER_MATCH_MODE_SUBSTRING
            case .prefix:
                return GTK_STRING_FILTER_MATCH_MODE_PREFIX
        }
    }
}
