import CGtk3

/// Specifies a preference for height-for-width or
/// width-for-height geometry management.
public enum SizeRequestMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSizeRequestMode

    /// Prefer height-for-width geometry management
    case heightForWidth
    /// Prefer width-for-height geometry management
    case widthForHeight
    /// Don’t trade height-for-width or width-for-height
    case constantSize

    public static var type: GType {
        gtk_size_request_mode_get_type()
    }

    public init(from gtkEnum: GtkSizeRequestMode) {
        switch gtkEnum {
            case GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH:
                self = .heightForWidth
            case GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT:
                self = .widthForHeight
            case GTK_SIZE_REQUEST_CONSTANT_SIZE:
                self = .constantSize
            default:
                fatalError("Unsupported GtkSizeRequestMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkSizeRequestMode {
        switch self {
            case .heightForWidth:
                return GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH
            case .widthForHeight:
                return GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT
            case .constantSize:
                return GTK_SIZE_REQUEST_CONSTANT_SIZE
        }
    }
}
