import CGtk

/// The available modes for [property@Gtk.CellRendererAccel:accel-mode].
public enum CellRendererAccelMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkCellRendererAccelMode

    /// GTK accelerators mode
    case gtk
    /// Other accelerator mode
    case other

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkCellRendererAccelMode {
        switch self {
            case .gtk:
                return GTK_CELL_RENDERER_ACCEL_MODE_GTK
            case .other:
                return GTK_CELL_RENDERER_ACCEL_MODE_OTHER
        }
    }
}
