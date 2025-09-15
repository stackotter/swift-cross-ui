import CGtk

/// The possible accessible relations of a [iface@Accessible].
///
/// Accessible relations can be references to other widgets,
/// integers or strings.
public enum AccessibleRelation: GValueRepresentableEnum {
    public typealias GtkEnum = GtkAccessibleRelation

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
    /// Identifies the element (or elements) that
    /// provide an error message for an object. Value type: reference
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

    public static var type: GType {
        gtk_accessible_relation_get_type()
    }

    public init(from gtkEnum: GtkAccessibleRelation) {
        switch gtkEnum {
            case GTK_ACCESSIBLE_RELATION_ACTIVE_DESCENDANT:
                self = .activeDescendant
            case GTK_ACCESSIBLE_RELATION_COL_COUNT:
                self = .colCount
            case GTK_ACCESSIBLE_RELATION_COL_INDEX:
                self = .colIndex
            case GTK_ACCESSIBLE_RELATION_COL_INDEX_TEXT:
                self = .colIndexText
            case GTK_ACCESSIBLE_RELATION_COL_SPAN:
                self = .colSpan
            case GTK_ACCESSIBLE_RELATION_CONTROLS:
                self = .controls
            case GTK_ACCESSIBLE_RELATION_DESCRIBED_BY:
                self = .describedBy
            case GTK_ACCESSIBLE_RELATION_DETAILS:
                self = .details
            case GTK_ACCESSIBLE_RELATION_ERROR_MESSAGE:
                self = .errorMessage
            case GTK_ACCESSIBLE_RELATION_FLOW_TO:
                self = .flowTo
            case GTK_ACCESSIBLE_RELATION_LABELLED_BY:
                self = .labelledBy
            case GTK_ACCESSIBLE_RELATION_OWNS:
                self = .owns
            case GTK_ACCESSIBLE_RELATION_POS_IN_SET:
                self = .posInSet
            case GTK_ACCESSIBLE_RELATION_ROW_COUNT:
                self = .rowCount
            case GTK_ACCESSIBLE_RELATION_ROW_INDEX:
                self = .rowIndex
            case GTK_ACCESSIBLE_RELATION_ROW_INDEX_TEXT:
                self = .rowIndexText
            case GTK_ACCESSIBLE_RELATION_ROW_SPAN:
                self = .rowSpan
            case GTK_ACCESSIBLE_RELATION_SET_SIZE:
                self = .setSize
            default:
                fatalError("Unsupported GtkAccessibleRelation enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkAccessibleRelation {
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
