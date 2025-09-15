import CGtk3

/// Determines if the edited accelerators are GTK+ accelerators. If
/// they are, consumed modifiers are suppressed, only accelerators
/// accepted by GTK+ are allowed, and the accelerators are rendered
/// in the same way as they are in menus.
public enum CellRendererAccelMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkCellRendererAccelMode

    /// GTK+ accelerators mode
    case gtk
    /// Other accelerator mode
    case other

    public static var type: GType {
        gtk_cell_renderer_accel_mode_get_type()
    }

    public init(from gtkEnum: GtkCellRendererAccelMode) {
        switch gtkEnum {
            case GTK_CELL_RENDERER_ACCEL_MODE_GTK:
                self = .gtk
            case GTK_CELL_RENDERER_ACCEL_MODE_OTHER:
                self = .other
            default:
                fatalError("Unsupported GtkCellRendererAccelMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkCellRendererAccelMode {
        switch self {
            case .gtk:
                return GTK_CELL_RENDERER_ACCEL_MODE_GTK
            case .other:
                return GTK_CELL_RENDERER_ACCEL_MODE_OTHER
        }
    }
}
