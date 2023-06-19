import CGtk

/// Used to indicate which grid lines to draw in a tree view.
public enum TreeViewGridLines: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTreeViewGridLines

    /// No grid lines.
    case none
    /// Horizontal grid lines.
    case horizontal
    /// Vertical grid lines.
    case vertical
    /// Horizontal and vertical grid lines.
    case both

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkTreeViewGridLines) {
        switch gtkEnum {
            case GTK_TREE_VIEW_GRID_LINES_NONE:
                self = .none
            case GTK_TREE_VIEW_GRID_LINES_HORIZONTAL:
                self = .horizontal
            case GTK_TREE_VIEW_GRID_LINES_VERTICAL:
                self = .vertical
            case GTK_TREE_VIEW_GRID_LINES_BOTH:
                self = .both
            default:
                fatalError("Unsupported GtkTreeViewGridLines enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkTreeViewGridLines {
        switch self {
            case .none:
                return GTK_TREE_VIEW_GRID_LINES_NONE
            case .horizontal:
                return GTK_TREE_VIEW_GRID_LINES_HORIZONTAL
            case .vertical:
                return GTK_TREE_VIEW_GRID_LINES_VERTICAL
            case .both:
                return GTK_TREE_VIEW_GRID_LINES_BOTH
        }
    }
}
