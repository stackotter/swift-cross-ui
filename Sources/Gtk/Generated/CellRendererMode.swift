import CGtk

/// Identifies how the user can interact with a particular cell.
public enum CellRendererMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkCellRendererMode

    /// The cell is just for display
/// and cannot be interacted with.  Note that this doesn’t mean that eg. the
/// row being drawn can’t be selected -- just that a particular element of
/// it cannot be individually modified.
case inert
/// The cell can be clicked.
case activatable
/// The cell can be edited or otherwise modified.
case editable

    public static var type: GType {
    gtk_cell_renderer_mode_get_type()
}

    public init(from gtkEnum: GtkCellRendererMode) {
        switch gtkEnum {
            case GTK_CELL_RENDERER_MODE_INERT:
    self = .inert
case GTK_CELL_RENDERER_MODE_ACTIVATABLE:
    self = .activatable
case GTK_CELL_RENDERER_MODE_EDITABLE:
    self = .editable
            default:
                fatalError("Unsupported GtkCellRendererMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkCellRendererMode {
        switch self {
            case .inert:
    return GTK_CELL_RENDERER_MODE_INERT
case .activatable:
    return GTK_CELL_RENDERER_MODE_ACTIVATABLE
case .editable:
    return GTK_CELL_RENDERER_MODE_EDITABLE
        }
    }
}