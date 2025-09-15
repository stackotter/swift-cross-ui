import CGtk3

public enum ResizeMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkResizeMode

    /// Pass resize request to the parent
    case parent
    /// Queue resizes on this widget
    case queue
    /// Resize immediately. Deprecated.
    case immediate

    public static var type: GType {
        gtk_resize_mode_get_type()
    }

    public init(from gtkEnum: GtkResizeMode) {
        switch gtkEnum {
            case GTK_RESIZE_PARENT:
                self = .parent
            case GTK_RESIZE_QUEUE:
                self = .queue
            case GTK_RESIZE_IMMEDIATE:
                self = .immediate
            default:
                fatalError("Unsupported GtkResizeMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkResizeMode {
        switch self {
            case .parent:
                return GTK_RESIZE_PARENT
            case .queue:
                return GTK_RESIZE_QUEUE
            case .immediate:
                return GTK_RESIZE_IMMEDIATE
        }
    }
}
