import CGtk

/// An enum for determining where a dropped row goes.
public enum TreeViewDropPosition {
    /// Dropped row is inserted before
    case before
    /// Dropped row is inserted after
    case after
    /// Dropped row becomes a child or is inserted before
    case intoOrBefore
    /// Dropped row becomes a child or is inserted after
    case intoOrAfter

    /// Converts the value to its corresponding Gtk representation.
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
    /// Converts a Gtk value to its corresponding swift representation.
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
