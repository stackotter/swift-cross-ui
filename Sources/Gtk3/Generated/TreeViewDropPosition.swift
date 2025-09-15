import CGtk3

/// An enum for determining where a dropped row goes.
public enum TreeViewDropPosition: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTreeViewDropPosition

    /// Dropped row is inserted before
    case before
    /// Dropped row is inserted after
    case after
    /// Dropped row becomes a child or is inserted before
    case intoOrBefore
    /// Dropped row becomes a child or is inserted after
    case intoOrAfter

    public static var type: GType {
        gtk_tree_view_drop_position_get_type()
    }

    public init(from gtkEnum: GtkTreeViewDropPosition) {
        switch gtkEnum {
            case GTK_TREE_VIEW_DROP_BEFORE:
                self = .before
            case GTK_TREE_VIEW_DROP_AFTER:
                self = .after
            case GTK_TREE_VIEW_DROP_INTO_OR_BEFORE:
                self = .intoOrBefore
            case GTK_TREE_VIEW_DROP_INTO_OR_AFTER:
                self = .intoOrAfter
            default:
                fatalError("Unsupported GtkTreeViewDropPosition enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkTreeViewDropPosition {
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
