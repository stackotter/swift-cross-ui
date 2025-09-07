import CGtk

/// Domain for VFL parsing errors.
public enum ConstraintVflParserError: GValueRepresentableEnum {
    public typealias GtkEnum = GtkConstraintVflParserError

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

    public static var type: GType {
        gtk_constraint_vfl_parser_error_get_type()
    }

    public init(from gtkEnum: GtkConstraintVflParserError) {
        switch gtkEnum {
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_SYMBOL:
                self = .symbol
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_ATTRIBUTE:
                self = .attribute
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_VIEW:
                self = .view
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_METRIC:
                self = .metric
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_PRIORITY:
                self = .priority
            case GTK_CONSTRAINT_VFL_PARSER_ERROR_INVALID_RELATION:
                self = .relation
            default:
                fatalError(
                    "Unsupported GtkConstraintVflParserError enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkConstraintVflParserError {
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
