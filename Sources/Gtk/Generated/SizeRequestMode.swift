import CGtk

/// Specifies a preference for height-for-width or
/// width-for-height geometry management.
public enum SizeRequestMode {
    /// Prefer height-for-width geometry management
    case heightForWidth
    /// Prefer width-for-height geometry management
    case widthForHeight
    /// Don’t trade height-for-width or width-for-height
    case constantSize

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSizeRequestMode() -> GtkSizeRequestMode {
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

extension GtkSizeRequestMode {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSizeRequestMode() -> SizeRequestMode {
        switch self {
            case GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH:
                return .heightForWidth
            case GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT:
                return .widthForHeight
            case GTK_SIZE_REQUEST_CONSTANT_SIZE:
                return .constantSize
            default:
                fatalError("Unsupported GtkSizeRequestMode enum value: \(self.rawValue)")
        }
    }
}
