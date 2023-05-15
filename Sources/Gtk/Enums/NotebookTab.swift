import CGtk

/// [Gtk docs](https://docs.gtk.org/gtk3/enum.NotebookTab.html)
public enum NotebookTab {
    case first
    case last

    func toGtkNotebookTab() -> GtkNotebookTab {
        switch self {
        case .first:
            return GTK_NOTEBOOK_TAB_FIRST
        case .last:
            return GTK_NOTEBOOK_TAB_LAST
        }
    }
}

extension GtkNotebookTab {
    func toNotebookTab() -> NotebookTab {
        switch self {
        case GTK_NOTEBOOK_TAB_FIRST:
            return .first
        case GTK_NOTEBOOK_TAB_LAST:
            return .last
        default:
            fatalError("Unsupported GtkNotebookTab enum value: \(self.rawValue)")
        }
    }
}
