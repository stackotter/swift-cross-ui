import CGtk3

/// Error codes for %GTK_CSS_PROVIDER_ERROR.
public enum CssProviderError: GValueRepresentableEnum {
    public typealias GtkEnum = GtkCssProviderError

    /// Failed.
    case failed
    /// Syntax error.
    case syntax
    /// Import error.
    case import_
    /// Name error.
    case name
    /// Deprecation error.
    case deprecated
    /// Unknown value.
    case unknownValue

    public static var type: GType {
        gtk_css_provider_error_get_type()
    }

    public init(from gtkEnum: GtkCssProviderError) {
        switch gtkEnum {
            case GTK_CSS_PROVIDER_ERROR_FAILED:
                self = .failed
            case GTK_CSS_PROVIDER_ERROR_SYNTAX:
                self = .syntax
            case GTK_CSS_PROVIDER_ERROR_IMPORT:
                self = .import_
            case GTK_CSS_PROVIDER_ERROR_NAME:
                self = .name
            case GTK_CSS_PROVIDER_ERROR_DEPRECATED:
                self = .deprecated
            case GTK_CSS_PROVIDER_ERROR_UNKNOWN_VALUE:
                self = .unknownValue
            default:
                fatalError("Unsupported GtkCssProviderError enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkCssProviderError {
        switch self {
            case .failed:
                return GTK_CSS_PROVIDER_ERROR_FAILED
            case .syntax:
                return GTK_CSS_PROVIDER_ERROR_SYNTAX
            case .import_:
                return GTK_CSS_PROVIDER_ERROR_IMPORT
            case .name:
                return GTK_CSS_PROVIDER_ERROR_NAME
            case .deprecated:
                return GTK_CSS_PROVIDER_ERROR_DEPRECATED
            case .unknownValue:
                return GTK_CSS_PROVIDER_ERROR_UNKNOWN_VALUE
        }
    }
}
