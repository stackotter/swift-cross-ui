import CGtk

/// Determines if the edited accelerators are GTK+ accelerators. If they are, consumed modifiers are suppressed, only accelerators accepted by GTK+ are allowed, and the accelerators are rendered in the same way as they are in menus.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.CellRendererAccelMode.html)
public enum CellRendererAccelMode {
    /// GTK+ accelerators mode.
    case gtk
    /// Other accelerator mode.
    case other

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
