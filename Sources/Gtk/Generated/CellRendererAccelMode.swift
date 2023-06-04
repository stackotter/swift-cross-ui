import CGtk

/// The available modes for [property@Gtk.CellRendererAccel:accel-mode].
public enum CellRendererAccelMode {
    /// GTK accelerators mode
    case gtk
    /// Other accelerator mode
    case other

    /// Converts the value to its corresponding Gtk representation.
    func toGtkCellRendererAccelMode() -> GtkCellRendererAccelMode {
        switch self {
            case .gtk:
                return GTK_CELL_RENDERER_ACCEL_MODE_GTK
            case .other:
                return GTK_CELL_RENDERER_ACCEL_MODE_OTHER
        }
    }
}

extension GtkCellRendererAccelMode {
    /// Converts a Gtk value to its corresponding swift representation.
    func toCellRendererAccelMode() -> CellRendererAccelMode {
        switch self {
            case GTK_CELL_RENDERER_ACCEL_MODE_GTK:
                return .gtk
            case GTK_CELL_RENDERER_ACCEL_MODE_OTHER:
                return .other
            default:
                fatalError("Unsupported GtkCellRendererAccelMode enum value: \(self.rawValue)")
        }
    }
}
