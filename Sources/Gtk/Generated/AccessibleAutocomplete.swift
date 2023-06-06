import CGtk

/// The possible values for the %GTK_ACCESSIBLE_PROPERTY_AUTOCOMPLETE
/// accessible property.
public enum AccessibleAutocomplete: GValueRepresentableEnum {
    public typealias GtkEnum = GtkAccessibleAutocomplete

    /// Automatic suggestions are not displayed.
    case none
    /// When a user is providing input, text
    /// suggesting one way to complete the provided input may be dynamically
    /// inserted after the caret.
    case inline
    /// When a user is providing input, an element
    /// containing a collection of values that could complete the provided input
    /// may be displayed.
    case list
    /// When a user is providing input, an element
    /// containing a collection of values that could complete the provided input
    /// may be displayed. If displayed, one value in the collection is automatically
    /// selected, and the text needed to complete the automatically selected value
    /// appears after the caret in the input.
    case both

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkAccessibleAutocomplete) {
        switch gtkEnum {
            case GTK_ACCESSIBLE_AUTOCOMPLETE_NONE:
                self = .none
            case GTK_ACCESSIBLE_AUTOCOMPLETE_INLINE:
                self = .inline
            case GTK_ACCESSIBLE_AUTOCOMPLETE_LIST:
                self = .list
            case GTK_ACCESSIBLE_AUTOCOMPLETE_BOTH:
                self = .both
            default:
                fatalError("Unsupported GtkAccessibleAutocomplete enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkAccessibleAutocomplete {
        switch self {
            case .none:
                return GTK_ACCESSIBLE_AUTOCOMPLETE_NONE
            case .inline:
                return GTK_ACCESSIBLE_AUTOCOMPLETE_INLINE
            case .list:
                return GTK_ACCESSIBLE_AUTOCOMPLETE_LIST
            case .both:
                return GTK_ACCESSIBLE_AUTOCOMPLETE_BOTH
        }
    }
}
