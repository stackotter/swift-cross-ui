import CGtk3

/// The sizing method the column uses to determine its width.  Please note
/// that @GTK_TREE_VIEW_COLUMN_AUTOSIZE are inefficient for large views, and
/// can make columns appear choppy.
public enum TreeViewColumnSizing: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTreeViewColumnSizing

    /// Columns only get bigger in reaction to changes in the model
    case growOnly
    /// Columns resize to be the optimal size everytime the model changes.
    case autosize
    /// Columns are a fixed numbers of pixels wide.
    case fixed

    public static var type: GType {
        gtk_tree_view_column_sizing_get_type()
    }

    public init(from gtkEnum: GtkTreeViewColumnSizing) {
        switch gtkEnum {
            case GTK_TREE_VIEW_COLUMN_GROW_ONLY:
                self = .growOnly
            case GTK_TREE_VIEW_COLUMN_AUTOSIZE:
                self = .autosize
            case GTK_TREE_VIEW_COLUMN_FIXED:
                self = .fixed
            default:
                fatalError("Unsupported GtkTreeViewColumnSizing enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkTreeViewColumnSizing {
        switch self {
            case .growOnly:
                return GTK_TREE_VIEW_COLUMN_GROW_ONLY
            case .autosize:
                return GTK_TREE_VIEW_COLUMN_AUTOSIZE
            case .fixed:
                return GTK_TREE_VIEW_COLUMN_FIXED
        }
    }
}
