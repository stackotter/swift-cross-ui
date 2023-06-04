import CGtk

/// Used to indicate which grid lines to draw in a tree view.
public enum TreeViewGridLines {
    /// No grid lines.
    case none
    /// Horizontal grid lines.
    case horizontal
    /// Vertical grid lines.
    case vertical
    /// Horizontal and vertical grid lines.
    case both

    /// Converts the value to its corresponding Gtk representation.
    func toGtkTreeViewGridLines() -> GtkTreeViewGridLines {
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

extension GtkTreeViewGridLines {
    /// Converts a Gtk value to its corresponding swift representation.
    func toTreeViewGridLines() -> TreeViewGridLines {
        switch self {
            case GTK_TREE_VIEW_GRID_LINES_NONE:
                return .none
            case GTK_TREE_VIEW_GRID_LINES_HORIZONTAL:
                return .horizontal
            case GTK_TREE_VIEW_GRID_LINES_VERTICAL:
                return .vertical
            case GTK_TREE_VIEW_GRID_LINES_BOTH:
                return .both
            default:
                fatalError("Unsupported GtkTreeViewGridLines enum value: \(self.rawValue)")
        }
    }
}
