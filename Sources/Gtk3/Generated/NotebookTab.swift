import CGtk3


public enum NotebookTab: GValueRepresentableEnum {
    public typealias GtkEnum = GtkNotebookTab

    
case first

case last

    public static var type: GType {
    gtk_notebook_tab_get_type()
}

    public init(from gtkEnum: GtkNotebookTab) {
        switch gtkEnum {
            case GTK_NOTEBOOK_TAB_FIRST:
    self = .first
case GTK_NOTEBOOK_TAB_LAST:
    self = .last
            default:
                fatalError("Unsupported GtkNotebookTab enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkNotebookTab {
        switch self {
            case .first:
    return GTK_NOTEBOOK_TAB_FIRST
case .last:
    return GTK_NOTEBOOK_TAB_LAST
        }
    }
}