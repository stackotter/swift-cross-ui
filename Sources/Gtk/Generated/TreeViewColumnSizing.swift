import CGtk

/// The sizing method the column uses to determine its width.  Please note
/// that %GTK_TREE_VIEW_COLUMN_AUTOSIZE are inefficient for large views, and
/// can make columns appear choppy.
public enum TreeViewColumnSizing: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTreeViewColumnSizing

    /// Columns only get bigger in reaction to changes in the model
    case growOnly
    /// Columns resize to be the optimal size every time the model changes.
    case autosize
    /// Columns are a fixed numbers of pixels wide.
    case fixed

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
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
