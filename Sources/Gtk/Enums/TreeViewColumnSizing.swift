import CGtk

/// The sizing method the column uses to determine its width. Please note that
/// `GTK_TREE_VIEW_COLUMN_AUTOSIZE` are inefficient for large views, and can make columns appear
/// choppy.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.TreeViewColumnSizing.html)
public enum TreeViewColumnSizing {
    /// Columns only get bigger in reaction to changes in the model.
    case growOnly
    /// Columns resize to be the optimal size everytime the model changes.
    case auto
    /// Columns are a fixed numbers of pixels wide.
    case fixed

    func toGtkTreeViewColumnSizing() -> GtkTreeViewColumnSizing {
        switch self {
            case .growOnly:
                return GTK_TREE_VIEW_COLUMN_GROW_ONLY
            case .auto:
                return GTK_TREE_VIEW_COLUMN_AUTOSIZE
            case .fixed:
                return GTK_TREE_VIEW_COLUMN_FIXED
        }
    }
}

extension GtkTreeViewColumnSizing {
    func toTreeViewColumnSizing() -> TreeViewColumnSizing {
        switch self {
            case GTK_TREE_VIEW_COLUMN_GROW_ONLY:
                return .growOnly
            case GTK_TREE_VIEW_COLUMN_AUTOSIZE:
                return .auto
            case GTK_TREE_VIEW_COLUMN_FIXED:
                return .fixed
            default:
                fatalError("Unsupported GtkTreeViewColumnSizing enum value: \(self.rawValue)")
        }
    }
}
