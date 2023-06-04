import CGtk

/// Domain for VFL parsing errors.
public enum ConstraintVflParserError {
    /// Invalid or unknown symbol
    case symbol
    /// Invalid or unknown attribute
    case attribute
    /// Invalid or unknown view
    case view
    /// Invalid or unknown metric
    case metric
    /// Invalid or unknown priority
    case priority
    /// Invalid or unknown relation
    case relation

    /// Converts the value to its corresponding Gtk representation.
    func toGtkConstraintVflParserError() -> GtkConstraintVflParserError {
        switch self {
            case .symbol:
                return GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_SYMBOL
            case .attribute:
                return GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_ATTRIBUTE
            case .view:
                return GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_VIEW
            case .metric:
                return GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_METRIC
            case .priority:
                return GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_PRIORITY
            case .relation:
                return GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_RELATION
        }
    }
}

extension GtkConstraintVflParserError {
    /// Converts a Gtk value to its corresponding swift representation.
    func toConstraintVflParserError() -> ConstraintVflParserError {
        switch self {
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_SYMBOL:
                return .symbol
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_ATTRIBUTE:
                return .attribute
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_VIEW:
                return .view
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_METRIC:
                return .metric
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_PRIORITY:
                return .priority
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_RELATION:
                return .relation
            default:
                fatalError("Unsupported GtkConstraintVflParserError enum value: \(self.rawValue)")
        }
    }
}
