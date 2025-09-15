import CGtk3

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

    public static var type: GType {
        gtk_tree_view_grid_lines_get_type()
    }

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
