import CGtk

/// The parameter used in the action signals of `GtkNotebook`.
public enum NotebookTab {
    /// The first tab in the notebook
    case first
    /// The last tab in the notebook
    case last

    /// Converts the value to its corresponding Gtk representation.
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
    /// Converts a Gtk value to its corresponding swift representation.
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
