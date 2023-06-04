import CGtk

/// The possible accessible relations of a [iface@Accessible].
///
/// Accessible relations can be references to other widgets,
/// integers or strings.
public enum AccessibleRelation {
    /// Identifies the currently active
    /// element when focus is on a composite widget, combobox, textbox, group,
    /// or application. Value type: reference
    case activeDescendant
    /// Defines the total number of columns
    /// in a table, grid, or treegrid. Value type: integer
    case colCount
    /// Defines an element's column index or
    /// position with respect to the total number of columns within a table,
    /// grid, or treegrid. Value type: integer
    case colIndex
    /// Defines a human readable text
    /// alternative of %GTK_ACCESSIBLE_RELATION_COL_INDEX. Value type: string
    case colIndexText
    /// Defines the number of columns spanned
    /// by a cell or gridcell within a table, grid, or treegrid. Value type: integer
    case colSpan
    /// Identifies the element (or elements) whose
    /// contents or presence are controlled by the current element. Value type: reference
    case controls
    /// Identifies the element (or elements)
    /// that describes the object. Value type: reference
    case describedBy
    /// Identifies the element (or elements) that
    /// provide additional information related to the object. Value type: reference
    case details
    /// Identifies the element that provides
    /// an error message for an object. Value type: reference
    case errorMessage
    /// Identifies the next element (or elements)
    /// in an alternate reading order of content which, at the user's discretion,
    /// allows assistive technology to override the general default of reading in
    /// document source order. Value type: reference
    case flowTo
    /// Identifies the element (or elements)
    /// that labels the current element. Value type: reference
    case labelledBy
    /// Identifies an element (or elements) in order
    /// to define a visual, functional, or contextual parent/child relationship
    /// between elements where the widget hierarchy cannot be used to represent
    /// the relationship. Value type: reference
    case owns
    /// Defines an element's number or position
    /// in the current set of listitems or treeitems. Value type: integer
    case posInSet
    /// Defines the total number of rows in a table,
    /// grid, or treegrid. Value type: integer
    case rowCount
    /// Defines an element's row index or position
    /// with respect to the total number of rows within a table, grid, or treegrid.
    /// Value type: integer
    case rowIndex
    /// Defines a human readable text
    /// alternative of aria-rowindex. Value type: string
    case rowIndexText
    /// Defines the number of rows spanned by a
    /// cell or gridcell within a table, grid, or treegrid. Value type: integer
    case rowSpan
    /// Defines the number of items in the current
    /// set of listitems or treeitems. Value type: integer
    case setSize

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessibleRelation() -> GtkAccessibleRelation {
        switch self {
            case .activeDescendant:
                return GTK_ACCESSIBLE_RELATION_ACTIVE_DESCENDANT
            case .colCount:
                return GTK_ACCESSIBLE_RELATION_COL_COUNT
            case .colIndex:
                return GTK_ACCESSIBLE_RELATION_COL_INDEX
            case .colIndexText:
                return GTK_ACCESSIBLE_RELATION_COL_INDEX_TEXT
            case .colSpan:
                return GTK_ACCESSIBLE_RELATION_COL_SPAN
            case .controls:
                return GTK_ACCESSIBLE_RELATION_CONTROLS
            case .describedBy:
                return GTK_ACCESSIBLE_RELATION_DESCRIBED_BY
            case .details:
                return GTK_ACCESSIBLE_RELATION_DETAILS
            case .errorMessage:
                return GTK_ACCESSIBLE_RELATION_ERROR_MESSAGE
            case .flowTo:
                return GTK_ACCESSIBLE_RELATION_FLOW_TO
            case .labelledBy:
                return GTK_ACCESSIBLE_RELATION_LABELLED_BY
            case .owns:
                return GTK_ACCESSIBLE_RELATION_OWNS
            case .posInSet:
                return GTK_ACCESSIBLE_RELATION_POS_IN_SET
            case .rowCount:
                return GTK_ACCESSIBLE_RELATION_ROW_COUNT
            case .rowIndex:
                return GTK_ACCESSIBLE_RELATION_ROW_INDEX
            case .rowIndexText:
                return GTK_ACCESSIBLE_RELATION_ROW_INDEX_TEXT
            case .rowSpan:
                return GTK_ACCESSIBLE_RELATION_ROW_SPAN
            case .setSize:
                return GTK_ACCESSIBLE_RELATION_SET_SIZE
        }
    }
}

extension GtkAccessibleRelation {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessibleRelation() -> AccessibleRelation {
        switch self {
            case GTK_ACCESSIBLE_RELATION_ACTIVE_DESCENDANT:
                return .activeDescendant
            case GTK_ACCESSIBLE_RELATION_COL_COUNT:
                return .colCount
            case GTK_ACCESSIBLE_RELATION_COL_INDEX:
                return .colIndex
            case GTK_ACCESSIBLE_RELATION_COL_INDEX_TEXT:
                return .colIndexText
            case GTK_ACCESSIBLE_RELATION_COL_SPAN:
                return .colSpan
            case GTK_ACCESSIBLE_RELATION_CONTROLS:
                return .controls
            case GTK_ACCESSIBLE_RELATION_DESCRIBED_BY:
                return .describedBy
            case GTK_ACCESSIBLE_RELATION_DETAILS:
                return .details
            case GTK_ACCESSIBLE_RELATION_ERROR_MESSAGE:
                return .errorMessage
            case GTK_ACCESSIBLE_RELATION_FLOW_TO:
                return .flowTo
            case GTK_ACCESSIBLE_RELATION_LABELLED_BY:
                return .labelledBy
            case GTK_ACCESSIBLE_RELATION_OWNS:
                return .owns
            case GTK_ACCESSIBLE_RELATION_POS_IN_SET:
                return .posInSet
            case GTK_ACCESSIBLE_RELATION_ROW_COUNT:
                return .rowCount
            case GTK_ACCESSIBLE_RELATION_ROW_INDEX:
                return .rowIndex
            case GTK_ACCESSIBLE_RELATION_ROW_INDEX_TEXT:
                return .rowIndexText
            case GTK_ACCESSIBLE_RELATION_ROW_SPAN:
                return .rowSpan
            case GTK_ACCESSIBLE_RELATION_SET_SIZE:
                return .setSize
            default:
                fatalError("Unsupported GtkAccessibleRelation enum value: \(self.rawValue)")
        }
    }
}
