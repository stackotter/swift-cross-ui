import CGtk

/// The parameter used in the action signals of `GtkNotebook`.
public enum NotebookTab: GValueRepresentableEnum {
    public typealias GtkEnum = GtkNotebookTab

    /// The first tab in the notebook
    case first
    /// The last tab in the notebook
    case last

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkNotebookTab {
        switch self {
            case .first:
                return GTK_NOTEBOOK_TAB_FIRST
            case .last:
                return GTK_NOTEBOOK_TAB_LAST
        }
    }
}
