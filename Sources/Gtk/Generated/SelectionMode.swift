import CGtk

/// Used to control what selections users are allowed to make.
public enum SelectionMode {
    /// No selection is possible.
    case none
    /// Zero or one element may be selected.
    case single
    /// Exactly one element is selected.
    /// In some circumstances, such as initially or during a search
    /// operation, it’s possible for no element to be selected with
    /// %GTK_SELECTION_BROWSE. What is really enforced is that the user
    /// can’t deselect a currently selected element except by selecting
    /// another element.
    case browse
    /// Any number of elements may be selected.
    /// The Ctrl key may be used to enlarge the selection, and Shift
    /// key to select between the focus and the child pointed to.
    /// Some widgets may also allow Click-drag to select a range of elements.
    case multiple

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSelectionMode() -> GtkSelectionMode {
        switch self {
            case .none:
                return GTK_SELECTION_NONE
            case .single:
                return GTK_SELECTION_SINGLE
            case .browse:
                return GTK_SELECTION_BROWSE
            case .multiple:
                return GTK_SELECTION_MULTIPLE
        }
    }
}

extension GtkSelectionMode {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSelectionMode() -> SelectionMode {
        switch self {
            case GTK_SELECTION_NONE:
                return .none
            case GTK_SELECTION_SINGLE:
                return .single
            case GTK_SELECTION_BROWSE:
                return .browse
            case GTK_SELECTION_MULTIPLE:
                return .multiple
            default:
                fatalError("Unsupported GtkSelectionMode enum value: \(self.rawValue)")
        }
    }
}
