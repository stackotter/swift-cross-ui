import CGtk

/// Warnings that can occur while parsing CSS.
///
/// Unlike `GtkCssParserError`s, warnings do not cause the parser to
/// skip any input, but they indicate issues that should be fixed.
public enum CssParserWarning {
    /// The given construct is
    /// deprecated and will be removed in a future version
    case deprecated
    /// A syntax construct was used
    /// that should be avoided
    case syntax
    /// A feature is not implemented
    case unimplemented

    /// Converts the value to its corresponding Gtk representation.
    func toGtkCssParserWarning() -> GtkCssParserWarning {
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

extension GtkCssParserWarning {
    /// Converts a Gtk value to its corresponding swift representation.
    func toCssParserWarning() -> CssParserWarning {
        switch self {
            case GTK_CSS_PARSER_WARNING_DEPRECATED:
                return .deprecated
            case GTK_CSS_PARSER_WARNING_SYNTAX:
                return .syntax
            case GTK_CSS_PARSER_WARNING_UNIMPLEMENTED:
                return .unimplemented
            default:
                fatalError("Unsupported GtkCssParserWarning enum value: \(self.rawValue)")
        }
    }
}
