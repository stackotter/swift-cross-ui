import CGtk

/// Errors that can occur while parsing CSS.
///
/// These errors are unexpected and will cause parts of the given CSS
/// to be ignored.
public enum CssParserError: GValueRepresentableEnum {
    public typealias GtkEnum = GtkCssParserError

    /// Unknown failure.
    case failed
    /// The given text does not form valid syntax
    case syntax
    /// Failed to import a resource
    case import_
    /// The given name has not been defined
    case name
    /// The given value is not correct
    case unknownValue

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkCssParserError) {
        switch gtkEnum {
            case GTK_CSS_PARSER_ERROR_FAILED:
                self = .failed
            case GTK_CSS_PARSER_ERROR_SYNTAX:
                self = .syntax
            case GTK_CSS_PARSER_ERROR_IMPORT:
                self = .import_
            case GTK_CSS_PARSER_ERROR_NAME:
                self = .name
            case GTK_CSS_PARSER_ERROR_UNKNOWN_VALUE:
                self = .unknownValue
            default:
                fatalError("Unsupported GtkCssParserError enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkCssParserError {
        switch self {
            case .failed:
                return GTK_CSS_PARSER_ERROR_FAILED
            case .syntax:
                return GTK_CSS_PARSER_ERROR_SYNTAX
            case .import_:
                return GTK_CSS_PARSER_ERROR_IMPORT
            case .name:
                return GTK_CSS_PARSER_ERROR_NAME
            case .unknownValue:
                return GTK_CSS_PARSER_ERROR_UNKNOWN_VALUE
        }
    }
}
