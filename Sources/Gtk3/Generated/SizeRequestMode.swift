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

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
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
