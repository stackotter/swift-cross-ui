import CGtk

/// Specifies how search strings are matched inside text.
public enum StringFilterMatchMode {
    /// The search string and
    /// text must match exactly.
    case exact
    /// The search string
    /// must be contained as a substring inside the text.
    case substring
    /// The text must begin
    /// with the search string.
    case prefix

    /// Converts the value to its corresponding Gtk representation.
    func toGtkStringFilterMatchMode() -> GtkStringFilterMatchMode {
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

extension GtkStringFilterMatchMode {
    /// Converts a Gtk value to its corresponding swift representation.
    func toStringFilterMatchMode() -> StringFilterMatchMode {
        switch self {
            case GTK_STRING_FILTER_MATCH_MODE_EXACT:
                return .exact
            case GTK_STRING_FILTER_MATCH_MODE_SUBSTRING:
                return .substring
            case GTK_STRING_FILTER_MATCH_MODE_PREFIX:
                return .prefix
            default:
                fatalError("Unsupported GtkStringFilterMatchMode enum value: \(self.rawValue)")
        }
    }
}
