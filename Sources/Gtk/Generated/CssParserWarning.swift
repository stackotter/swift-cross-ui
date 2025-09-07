import CGtk

/// Warnings that can occur while parsing CSS.
///
/// Unlike `GtkCssParserError`s, warnings do not cause the parser to
/// skip any input, but they indicate issues that should be fixed.
public enum CssParserWarning: GValueRepresentableEnum {
    public typealias GtkEnum = GtkCssParserWarning

    /// The given construct is
    /// deprecated and will be removed in a future version
    case deprecated
    /// A syntax construct was used
    /// that should be avoided
    case syntax
    /// A feature is not implemented
    case unimplemented

    public static var type: GType {
        gtk_css_parser_warning_get_type()
    }

    public init(from gtkEnum: GtkCssParserWarning) {
        switch gtkEnum {
            case GTK_CSS_PARSER_WARNING_DEPRECATED:
                self = .deprecated
            case GTK_CSS_PARSER_WARNING_SYNTAX:
                self = .syntax
            case GTK_CSS_PARSER_WARNING_UNIMPLEMENTED:
                self = .unimplemented
            default:
                fatalError("Unsupported GtkCssParserWarning enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkCssParserWarning {
        switch self {
            case .deprecated:
                return GTK_CSS_PARSER_WARNING_DEPRECATED
            case .syntax:
                return GTK_CSS_PARSER_WARNING_SYNTAX
            case .unimplemented:
                return GTK_CSS_PARSER_WARNING_UNIMPLEMENTED
        }
    }
}
