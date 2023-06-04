import CGtk

/// The accessible role for a [iface@Accessible] implementation.
///
/// Abstract roles are only used as part of the ontology; application
/// developers must not use abstract roles in their code.
public enum AccessibleRole {
    /// An element with important, and usually
    /// time-sensitive, information
    case alert
    /// A type of dialog that contains an
    /// alert message
    case alertDialog
    /// Unused
    case banner
    /// An input element that allows for
    /// user-triggered actions when clicked or pressed
    case button
    /// Unused
    case caption
    /// Unused
    case cell
    /// A checkable input element that has
    /// three possible values: `true`, `false`, or `mixed`
    case checkbox
    /// A header in a columned list.
    case columnHeader
    /// An input that controls another element,
    /// such as a list or a grid, that can dynamically pop up to help the user
    /// set the value of the input
    case comboBox
    /// Abstract role.
    case command
    /// Abstract role.
    case composite
    /// A dialog is a window that is designed to interrupt
    /// the current processing of an application in order to prompt the user to enter
    /// information or require a response.
    case dialog
    /// Unused
    case document
    /// Unused
    case feed
    /// Unused
    case form
    /// Unused
    case generic
    /// A grid of items.
    case grid
    /// An item in a grid or tree grid.
    case gridCell
    /// An element that groups multiple widgets. GTK uses
    /// this role for various containers, like [class@Box], [class@Viewport], and [class@HeaderBar].
    case group
    /// Unused
    case heading
    /// An image.
    case img
    /// Abstract role.
    case input
    /// A visible name or caption for a user interface component.
    case label
    /// Abstract role.
    case landmark
    /// Unused
    case legend
    /// A clickable link.
    case link
    /// A list of items.
    case list
    /// Unused.
    case listBox
    /// An item in a list.
    case listItem
    /// Unused
    case log
    /// Unused
    case main
    /// Unused
    case marquee
    /// Unused
    case math
    /// An element that represents a value within a known range.
    case meter
    /// A menu.
    case menu
    /// A menubar.
    case menuBar
    /// An item in a menu.
    case menuItem
    /// A check item in a menu.
    case menuItemCheckbox
    /// A radio item in a menu.
    case menuItemRadio
    /// Unused
    case navigation
    /// An element that is not represented to accessibility technologies.
    case none
    /// Unused
    case note
    /// Unused
    case option
    /// An element that is not represented to accessibility technologies.
    case presentation
    /// An element that displays the progress
    /// status for tasks that take a long time.
    case progressBar
    /// A checkable input in a group of radio roles,
    /// only one of which can be checked at a time.
    case radio
    /// Unused
    case radioGroup
    /// Abstract role.
    case range
    /// Unused
    case region
    /// A row in a columned list.
    case row
    /// Unused
    case rowGroup
    /// Unused
    case rowHeader
    /// A graphical object that controls the scrolling
    /// of content within a viewing area, regardless of whether the content is fully
    /// displayed within the viewing area.
    case scrollbar
    /// Unused
    case search
    /// A type of textbox intended for specifying
    /// search criteria.
    case searchBox
    /// Abstract role.
    case section
    /// Abstract role.
    case sectionHead
    /// Abstract role.
    case select
    /// A divider that separates and distinguishes
    /// sections of content or groups of menuitems.
    case separator
    /// A user input where the user selects a value
    /// from within a given range.
    case slider
    /// A form of range that expects the user to
    /// select from among discrete choices.
    case spinButton
    /// Unused
    case status
    /// Abstract role.
    case structure
    /// A type of checkbox that represents on/off values,
    /// as opposed to checked/unchecked values.
    case switch_
    /// An item in a list of tab used for switching pages.
    case tab
    /// Unused
    case table
    /// A list of tabs for switching pages.
    case tabList
    /// A page in a notebook or stack.
    case tabPanel
    /// A type of input that allows free-form text
    /// as its value.
    case textBox
    /// Unused
    case time
    /// Unused
    case timer
    /// Unused
    case toolbar
    /// Unused
    case tooltip
    /// Unused
    case tree
    /// A treeview-like, columned list.
    case treeGrid
    /// Unused
    case treeItem
    /// An interactive component of a graphical user
    /// interface. This is the role that GTK uses by default for widgets.
    case widget
    /// An application window.
    case window

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessibleRole() -> GtkAccessibleRole {
        switch self {
            case .alert:
                return GTK_ACCESSIBLE_ROLE_ALERT
            case .alertDialog:
                return GTK_ACCESSIBLE_ROLE_ALERT_DIALOG
            case .banner:
                return GTK_ACCESSIBLE_ROLE_BANNER
            case .button:
                return GTK_ACCESSIBLE_ROLE_BUTTON
            case .caption:
                return GTK_ACCESSIBLE_ROLE_CAPTION
            case .cell:
                return GTK_ACCESSIBLE_ROLE_CELL
            case .checkbox:
                return GTK_ACCESSIBLE_ROLE_CHECKBOX
            case .columnHeader:
                return GTK_ACCESSIBLE_ROLE_COLUMN_HEADER
            case .comboBox:
                return GTK_ACCESSIBLE_ROLE_COMBO_BOX
            case .command:
                return GTK_ACCESSIBLE_ROLE_COMMAND
            case .composite:
                return GTK_ACCESSIBLE_ROLE_COMPOSITE
            case .dialog:
                return GTK_ACCESSIBLE_ROLE_DIALOG
            case .document:
                return GTK_ACCESSIBLE_ROLE_DOCUMENT
            case .feed:
                return GTK_ACCESSIBLE_ROLE_FEED
            case .form:
                return GTK_ACCESSIBLE_ROLE_FORM
            case .generic:
                return GTK_ACCESSIBLE_ROLE_GENERIC
            case .grid:
                return GTK_ACCESSIBLE_ROLE_GRID
            case .gridCell:
                return GTK_ACCESSIBLE_ROLE_GRID_CELL
            case .group:
                return GTK_ACCESSIBLE_ROLE_GROUP
            case .heading:
                return GTK_ACCESSIBLE_ROLE_HEADING
            case .img:
                return GTK_ACCESSIBLE_ROLE_IMG
            case .input:
                return GTK_ACCESSIBLE_ROLE_INPUT
            case .label:
                return GTK_ACCESSIBLE_ROLE_LABEL
            case .landmark:
                return GTK_ACCESSIBLE_ROLE_LANDMARK
            case .legend:
                return GTK_ACCESSIBLE_ROLE_LEGEND
            case .link:
                return GTK_ACCESSIBLE_ROLE_LINK
            case .list:
                return GTK_ACCESSIBLE_ROLE_LIST
            case .listBox:
                return GTK_ACCESSIBLE_ROLE_LIST_BOX
            case .listItem:
                return GTK_ACCESSIBLE_ROLE_LIST_ITEM
            case .log:
                return GTK_ACCESSIBLE_ROLE_LOG
            case .main:
                return GTK_ACCESSIBLE_ROLE_MAIN
            case .marquee:
                return GTK_ACCESSIBLE_ROLE_MARQUEE
            case .math:
                return GTK_ACCESSIBLE_ROLE_MATH
            case .meter:
                return GTK_ACCESSIBLE_ROLE_METER
            case .menu:
                return GTK_ACCESSIBLE_ROLE_MENU
            case .menuBar:
                return GTK_ACCESSIBLE_ROLE_MENU_BAR
            case .menuItem:
                return GTK_ACCESSIBLE_ROLE_MENU_ITEM
            case .menuItemCheckbox:
                return GTK_ACCESSIBLE_ROLE_MENU_ITEM_CHECKBOX
            case .menuItemRadio:
                return GTK_ACCESSIBLE_ROLE_MENU_ITEM_RADIO
            case .navigation:
                return GTK_ACCESSIBLE_ROLE_NAVIGATION
            case .none:
                return GTK_ACCESSIBLE_ROLE_NONE
            case .note:
                return GTK_ACCESSIBLE_ROLE_NOTE
            case .option:
                return GTK_ACCESSIBLE_ROLE_OPTION
            case .presentation:
                return GTK_ACCESSIBLE_ROLE_PRESENTATION
            case .progressBar:
                return GTK_ACCESSIBLE_ROLE_PROGRESS_BAR
            case .radio:
                return GTK_ACCESSIBLE_ROLE_RADIO
            case .radioGroup:
                return GTK_ACCESSIBLE_ROLE_RADIO_GROUP
            case .range:
                return GTK_ACCESSIBLE_ROLE_RANGE
            case .region:
                return GTK_ACCESSIBLE_ROLE_REGION
            case .row:
                return GTK_ACCESSIBLE_ROLE_ROW
            case .rowGroup:
                return GTK_ACCESSIBLE_ROLE_ROW_GROUP
            case .rowHeader:
                return GTK_ACCESSIBLE_ROLE_ROW_HEADER
            case .scrollbar:
                return GTK_ACCESSIBLE_ROLE_SCROLLBAR
            case .search:
                return GTK_ACCESSIBLE_ROLE_SEARCH
            case .searchBox:
                return GTK_ACCESSIBLE_ROLE_SEARCH_BOX
            case .section:
                return GTK_ACCESSIBLE_ROLE_SECTION
            case .sectionHead:
                return GTK_ACCESSIBLE_ROLE_SECTION_HEAD
            case .select:
                return GTK_ACCESSIBLE_ROLE_SELECT
            case .separator:
                return GTK_ACCESSIBLE_ROLE_SEPARATOR
            case .slider:
                return GTK_ACCESSIBLE_ROLE_SLIDER
            case .spinButton:
                return GTK_ACCESSIBLE_ROLE_SPIN_BUTTON
            case .status:
                return GTK_ACCESSIBLE_ROLE_STATUS
            case .structure:
                return GTK_ACCESSIBLE_ROLE_STRUCTURE
            case .switch_:
                return GTK_ACCESSIBLE_ROLE_SWITCH
            case .tab:
                return GTK_ACCESSIBLE_ROLE_TAB
            case .table:
                return GTK_ACCESSIBLE_ROLE_TABLE
            case .tabList:
                return GTK_ACCESSIBLE_ROLE_TAB_LIST
            case .tabPanel:
                return GTK_ACCESSIBLE_ROLE_TAB_PANEL
            case .textBox:
                return GTK_ACCESSIBLE_ROLE_TEXT_BOX
            case .time:
                return GTK_ACCESSIBLE_ROLE_TIME
            case .timer:
                return GTK_ACCESSIBLE_ROLE_TIMER
            case .toolbar:
                return GTK_ACCESSIBLE_ROLE_TOOLBAR
            case .tooltip:
                return GTK_ACCESSIBLE_ROLE_TOOLTIP
            case .tree:
                return GTK_ACCESSIBLE_ROLE_TREE
            case .treeGrid:
                return GTK_ACCESSIBLE_ROLE_TREE_GRID
            case .treeItem:
                return GTK_ACCESSIBLE_ROLE_TREE_ITEM
            case .widget:
                return GTK_ACCESSIBLE_ROLE_WIDGET
            case .window:
                return GTK_ACCESSIBLE_ROLE_WINDOW
        }
    }
}

extension GtkAccessibleRole {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessibleRole() -> AccessibleRole {
        switch self {
            case GTK_ACCESSIBLE_ROLE_ALERT:
                return .alert
            case GTK_ACCESSIBLE_ROLE_ALERT_DIALOG:
                return .alertDialog
            case GTK_ACCESSIBLE_ROLE_BANNER:
                return .banner
            case GTK_ACCESSIBLE_ROLE_BUTTON:
                return .button
            case GTK_ACCESSIBLE_ROLE_CAPTION:
                return .caption
            case GTK_ACCESSIBLE_ROLE_CELL:
                return .cell
            case GTK_ACCESSIBLE_ROLE_CHECKBOX:
                return .checkbox
            case GTK_ACCESSIBLE_ROLE_COLUMN_HEADER:
                return .columnHeader
            case GTK_ACCESSIBLE_ROLE_COMBO_BOX:
                return .comboBox
            case GTK_ACCESSIBLE_ROLE_COMMAND:
                return .command
            case GTK_ACCESSIBLE_ROLE_COMPOSITE:
                return .composite
            case GTK_ACCESSIBLE_ROLE_DIALOG:
                return .dialog
            case GTK_ACCESSIBLE_ROLE_DOCUMENT:
                return .document
            case GTK_ACCESSIBLE_ROLE_FEED:
                return .feed
            case GTK_ACCESSIBLE_ROLE_FORM:
                return .form
            case GTK_ACCESSIBLE_ROLE_GENERIC:
                return .generic
            case GTK_ACCESSIBLE_ROLE_GRID:
                return .grid
            case GTK_ACCESSIBLE_ROLE_GRID_CELL:
                return .gridCell
            case GTK_ACCESSIBLE_ROLE_GROUP:
                return .group
            case GTK_ACCESSIBLE_ROLE_HEADING:
                return .heading
            case GTK_ACCESSIBLE_ROLE_IMG:
                return .img
            case GTK_ACCESSIBLE_ROLE_INPUT:
                return .input
            case GTK_ACCESSIBLE_ROLE_LABEL:
                return .label
            case GTK_ACCESSIBLE_ROLE_LANDMARK:
                return .landmark
            case GTK_ACCESSIBLE_ROLE_LEGEND:
                return .legend
            case GTK_ACCESSIBLE_ROLE_LINK:
                return .link
            case GTK_ACCESSIBLE_ROLE_LIST:
                return .list
            case GTK_ACCESSIBLE_ROLE_LIST_BOX:
                return .listBox
            case GTK_ACCESSIBLE_ROLE_LIST_ITEM:
                return .listItem
            case GTK_ACCESSIBLE_ROLE_LOG:
                return .log
            case GTK_ACCESSIBLE_ROLE_MAIN:
                return .main
            case GTK_ACCESSIBLE_ROLE_MARQUEE:
                return .marquee
            case GTK_ACCESSIBLE_ROLE_MATH:
                return .math
            case GTK_ACCESSIBLE_ROLE_METER:
                return .meter
            case GTK_ACCESSIBLE_ROLE_MENU:
                return .menu
            case GTK_ACCESSIBLE_ROLE_MENU_BAR:
                return .menuBar
            case GTK_ACCESSIBLE_ROLE_MENU_ITEM:
                return .menuItem
            case GTK_ACCESSIBLE_ROLE_MENU_ITEM_CHECKBOX:
                return .menuItemCheckbox
            case GTK_ACCESSIBLE_ROLE_MENU_ITEM_RADIO:
                return .menuItemRadio
            case GTK_ACCESSIBLE_ROLE_NAVIGATION:
                return .navigation
            case GTK_ACCESSIBLE_ROLE_NONE:
                return .none
            case GTK_ACCESSIBLE_ROLE_NOTE:
                return .note
            case GTK_ACCESSIBLE_ROLE_OPTION:
                return .option
            case GTK_ACCESSIBLE_ROLE_PRESENTATION:
                return .presentation
            case GTK_ACCESSIBLE_ROLE_PROGRESS_BAR:
                return .progressBar
            case GTK_ACCESSIBLE_ROLE_RADIO:
                return .radio
            case GTK_ACCESSIBLE_ROLE_RADIO_GROUP:
                return .radioGroup
            case GTK_ACCESSIBLE_ROLE_RANGE:
                return .range
            case GTK_ACCESSIBLE_ROLE_REGION:
                return .region
            case GTK_ACCESSIBLE_ROLE_ROW:
                return .row
            case GTK_ACCESSIBLE_ROLE_ROW_GROUP:
                return .rowGroup
            case GTK_ACCESSIBLE_ROLE_ROW_HEADER:
                return .rowHeader
            case GTK_ACCESSIBLE_ROLE_SCROLLBAR:
                return .scrollbar
            case GTK_ACCESSIBLE_ROLE_SEARCH:
                return .search
            case GTK_ACCESSIBLE_ROLE_SEARCH_BOX:
                return .searchBox
            case GTK_ACCESSIBLE_ROLE_SECTION:
                return .section
            case GTK_ACCESSIBLE_ROLE_SECTION_HEAD:
                return .sectionHead
            case GTK_ACCESSIBLE_ROLE_SELECT:
                return .select
            case GTK_ACCESSIBLE_ROLE_SEPARATOR:
                return .separator
            case GTK_ACCESSIBLE_ROLE_SLIDER:
                return .slider
            case GTK_ACCESSIBLE_ROLE_SPIN_BUTTON:
                return .spinButton
            case GTK_ACCESSIBLE_ROLE_STATUS:
                return .status
            case GTK_ACCESSIBLE_ROLE_STRUCTURE:
                return .structure
            case GTK_ACCESSIBLE_ROLE_SWITCH:
                return .switch_
            case GTK_ACCESSIBLE_ROLE_TAB:
                return .tab
            case GTK_ACCESSIBLE_ROLE_TABLE:
                return .table
            case GTK_ACCESSIBLE_ROLE_TAB_LIST:
                return .tabList
            case GTK_ACCESSIBLE_ROLE_TAB_PANEL:
                return .tabPanel
            case GTK_ACCESSIBLE_ROLE_TEXT_BOX:
                return .textBox
            case GTK_ACCESSIBLE_ROLE_TIME:
                return .time
            case GTK_ACCESSIBLE_ROLE_TIMER:
                return .timer
            case GTK_ACCESSIBLE_ROLE_TOOLBAR:
                return .toolbar
            case GTK_ACCESSIBLE_ROLE_TOOLTIP:
                return .tooltip
            case GTK_ACCESSIBLE_ROLE_TREE:
                return .tree
            case GTK_ACCESSIBLE_ROLE_TREE_GRID:
                return .treeGrid
            case GTK_ACCESSIBLE_ROLE_TREE_ITEM:
                return .treeItem
            case GTK_ACCESSIBLE_ROLE_WIDGET:
                return .widget
            case GTK_ACCESSIBLE_ROLE_WINDOW:
                return .window
            default:
                fatalError("Unsupported GtkAccessibleRole enum value: \(self.rawValue)")
        }
    }
}
