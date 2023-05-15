import CGtk

/// An enum for determining where a dropped row goes.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.TreeViewDropPosition.html)
public enum TreeViewDropPosition {
    /// Dropped row is inserted before.
    case before
    /// Dropped row is inserted after.
    case after
    /// Dropped row becomes a child or is inserted before.
    case intoOrBefore
    /// Dropped row becomes a child or is inserted after.
    case intoOrAfter

    func toGtkTreeViewDropPosition() -> GtkTreeViewDropPosition {
        switch self {
        case .before:
            return GTK_TREE_VIEW_DROP_BEFORE
        case .after:
            return GTK_TREE_VIEW_DROP_AFTER
        case .intoOrBefore:
            return GTK_TREE_VIEW_DROP_INTO_OR_BEFORE
        case .intoOrAfter:
            return GTK_TREE_VIEW_DROP_INTO_OR_AFTER
        }
    }
}

extension GtkTreeViewDropPosition {
    func toTreeViewDropPosition() -> TreeViewDropPosition {
        switch self {
        case GTK_TREE_VIEW_DROP_BEFORE:
            return .before
        case GTK_TREE_VIEW_DROP_AFTER:
            return .after
        case GTK_TREE_VIEW_DROP_INTO_OR_BEFORE:
            return .intoOrBefore
        case GTK_TREE_VIEW_DROP_INTO_OR_AFTER:
            return .intoOrAfter
        default:
            fatalError("Unsupported GtkTreeViewDropPosition enum value: \(self.rawValue)")
        }
    }
}
