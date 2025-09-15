import CGtk3

/// Used to control what selections users are allowed to make.
public enum SelectionMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSelectionMode

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

    public static var type: GType {
        gtk_selection_mode_get_type()
    }

    public init(from gtkEnum: GtkSelectionMode) {
        switch gtkEnum {
            case GTK_SELECTION_NONE:
                self = .none
            case GTK_SELECTION_SINGLE:
                self = .single
            case GTK_SELECTION_BROWSE:
                self = .browse
            case GTK_SELECTION_MULTIPLE:
                self = .multiple
            default:
                fatalError("Unsupported GtkSelectionMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkSelectionMode {
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
