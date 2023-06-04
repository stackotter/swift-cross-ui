import CGtk

/// The possible accessible properties of a [iface@Accessible].
public enum AccessibleProperty {
    /// Indicates whether inputting text
    /// could trigger display of one or more predictions of the user's intended
    /// value for a combobox, searchbox, or textbox and specifies how predictions
    /// would be presented if they were made. Value type: [enum@AccessibleAutocomplete]
    case autocomplete
    /// Defines a string value that describes
    /// or annotates the current element. Value type: string
    case description
    /// Indicates the availability and type of
    /// interactive popup element, such as menu or dialog, that can be triggered
    /// by an element.
    case hasPopup
    /// Indicates keyboard shortcuts that an
    /// author has implemented to activate or give focus to an element. Value type:
    /// string
    case keyShortcuts
    /// Defines a string value that labels the current
    /// element. Value type: string
    case label
    /// Defines the hierarchical level of an element
    /// within a structure. Value type: integer
    case level
    /// Indicates whether an element is modal when
    /// displayed. Value type: boolean
    case modal
    /// Indicates whether a text box accepts
    /// multiple lines of input or only a single line. Value type: boolean
    case multiLine
    /// Indicates that the user may select
    /// more than one item from the current selectable descendants. Value type:
    /// boolean
    case multiSelectable
    /// Indicates whether the element's
    /// orientation is horizontal, vertical, or unknown/ambiguous. Value type:
    /// [enum@Orientation]
    case orientation
    /// Defines a short hint (a word or short
    /// phrase) intended to aid the user with data entry when the control has no
    /// value. A hint could be a sample value or a brief description of the expected
    /// format. Value type: string
    case placeholder
    /// Indicates that the element is not editable,
    /// but is otherwise operable. Value type: boolean
    case readOnly
    /// Indicates that user input is required on
    /// the element before a form may be submitted. Value type: boolean
    case required
    /// Defines a human-readable,
    /// author-localized description for the role of an element. Value type: string
    case roleDescription
    /// Indicates if items in a table or grid are
    /// sorted in ascending or descending order. Value type: [enum@AccessibleSort]
    case sort
    /// Defines the maximum allowed value for a
    /// range widget. Value type: double
    case valueMax
    /// Defines the minimum allowed value for a
    /// range widget. Value type: double
    case valueMin
    /// Defines the current value for a range widget.
    /// Value type: double
    case valueNow
    /// Defines the human readable text alternative
    /// of aria-valuenow for a range widget. Value type: string
    case valueText

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessibleProperty() -> GtkAccessibleProperty {
        switch self {
            case .autocomplete:
                return GTK_ACCESSIBLE_PROPERTY_AUTOCOMPLETE
            case .description:
                return GTK_ACCESSIBLE_PROPERTY_DESCRIPTION
            case .hasPopup:
                return GTK_ACCESSIBLE_PROPERTY_HAS_POPUP
            case .keyShortcuts:
                return GTK_ACCESSIBLE_PROPERTY_KEY_SHORTCUTS
            case .label:
                return GTK_ACCESSIBLE_PROPERTY_LABEL
            case .level:
                return GTK_ACCESSIBLE_PROPERTY_LEVEL
            case .modal:
                return GTK_ACCESSIBLE_PROPERTY_MODAL
            case .multiLine:
                return GTK_ACCESSIBLE_PROPERTY_MULTI_LINE
            case .multiSelectable:
                return GTK_ACCESSIBLE_PROPERTY_MULTI_SELECTABLE
            case .orientation:
                return GTK_ACCESSIBLE_PROPERTY_ORIENTATION
            case .placeholder:
                return GTK_ACCESSIBLE_PROPERTY_PLACEHOLDER
            case .readOnly:
                return GTK_ACCESSIBLE_PROPERTY_READ_ONLY
            case .required:
                return GTK_ACCESSIBLE_PROPERTY_REQUIRED
            case .roleDescription:
                return GTK_ACCESSIBLE_PROPERTY_ROLE_DESCRIPTION
            case .sort:
                return GTK_ACCESSIBLE_PROPERTY_SORT
            case .valueMax:
                return GTK_ACCESSIBLE_PROPERTY_VALUE_MAX
            case .valueMin:
                return GTK_ACCESSIBLE_PROPERTY_VALUE_MIN
            case .valueNow:
                return GTK_ACCESSIBLE_PROPERTY_VALUE_NOW
            case .valueText:
                return GTK_ACCESSIBLE_PROPERTY_VALUE_TEXT
        }
    }
}

extension GtkAccessibleProperty {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessibleProperty() -> AccessibleProperty {
        switch self {
            case GTK_ACCESSIBLE_PROPERTY_AUTOCOMPLETE:
                return .autocomplete
            case GTK_ACCESSIBLE_PROPERTY_DESCRIPTION:
                return .description
            case GTK_ACCESSIBLE_PROPERTY_HAS_POPUP:
                return .hasPopup
            case GTK_ACCESSIBLE_PROPERTY_KEY_SHORTCUTS:
                return .keyShortcuts
            case GTK_ACCESSIBLE_PROPERTY_LABEL:
                return .label
            case GTK_ACCESSIBLE_PROPERTY_LEVEL:
                return .level
            case GTK_ACCESSIBLE_PROPERTY_MODAL:
                return .modal
            case GTK_ACCESSIBLE_PROPERTY_MULTI_LINE:
                return .multiLine
            case GTK_ACCESSIBLE_PROPERTY_MULTI_SELECTABLE:
                return .multiSelectable
            case GTK_ACCESSIBLE_PROPERTY_ORIENTATION:
                return .orientation
            case GTK_ACCESSIBLE_PROPERTY_PLACEHOLDER:
                return .placeholder
            case GTK_ACCESSIBLE_PROPERTY_READ_ONLY:
                return .readOnly
            case GTK_ACCESSIBLE_PROPERTY_REQUIRED:
                return .required
            case GTK_ACCESSIBLE_PROPERTY_ROLE_DESCRIPTION:
                return .roleDescription
            case GTK_ACCESSIBLE_PROPERTY_SORT:
                return .sort
            case GTK_ACCESSIBLE_PROPERTY_VALUE_MAX:
                return .valueMax
            case GTK_ACCESSIBLE_PROPERTY_VALUE_MIN:
                return .valueMin
            case GTK_ACCESSIBLE_PROPERTY_VALUE_NOW:
                return .valueNow
            case GTK_ACCESSIBLE_PROPERTY_VALUE_TEXT:
                return .valueText
            default:
                fatalError("Unsupported GtkAccessibleProperty enum value: \(self.rawValue)")
        }
    }
}
