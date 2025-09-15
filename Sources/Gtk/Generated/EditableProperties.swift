import CGtk

/// The identifiers for [iface@Gtk.Editable] properties.
///
/// See [func@Gtk.Editable.install_properties] for details on how to
/// implement the `GtkEditable` interface.
public enum EditableProperties: GValueRepresentableEnum {
    public typealias GtkEnum = GtkEditableProperties

    /// The property id for [property@Gtk.Editable:text]
    case propText
    /// The property id for [property@Gtk.Editable:cursor-position]
    case propCursorPosition
    /// The property id for [property@Gtk.Editable:selection-bound]
    case propSelectionBound
    /// The property id for [property@Gtk.Editable:editable]
    case propEditable
    /// The property id for [property@Gtk.Editable:width-chars]
    case propWidthChars
    /// The property id for [property@Gtk.Editable:max-width-chars]
    case propMaxWidthChars
    /// The property id for [property@Gtk.Editable:xalign]
    case propXalign
    /// The property id for [property@Gtk.Editable:enable-undo]
    case propEnableUndo
    /// The number of properties
    case numProperties

    public static var type: GType {
        gtk_editable_properties_get_type()
    }

    public init(from gtkEnum: GtkEditableProperties) {
        switch gtkEnum {
            case GTK_EDITABLE_PROP_TEXT:
                self = .propText
            case GTK_EDITABLE_PROP_CURSOR_POSITION:
                self = .propCursorPosition
            case GTK_EDITABLE_PROP_SELECTION_BOUND:
                self = .propSelectionBound
            case GTK_EDITABLE_PROP_EDITABLE:
                self = .propEditable
            case GTK_EDITABLE_PROP_WIDTH_CHARS:
                self = .propWidthChars
            case GTK_EDITABLE_PROP_MAX_WIDTH_CHARS:
                self = .propMaxWidthChars
            case GTK_EDITABLE_PROP_XALIGN:
                self = .propXalign
            case GTK_EDITABLE_PROP_ENABLE_UNDO:
                self = .propEnableUndo
            case GTK_EDITABLE_NUM_PROPERTIES:
                self = .numProperties
            default:
                fatalError("Unsupported GtkEditableProperties enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkEditableProperties {
        switch self {
            case .propText:
                return GTK_EDITABLE_PROP_TEXT
            case .propCursorPosition:
                return GTK_EDITABLE_PROP_CURSOR_POSITION
            case .propSelectionBound:
                return GTK_EDITABLE_PROP_SELECTION_BOUND
            case .propEditable:
                return GTK_EDITABLE_PROP_EDITABLE
            case .propWidthChars:
                return GTK_EDITABLE_PROP_WIDTH_CHARS
            case .propMaxWidthChars:
                return GTK_EDITABLE_PROP_MAX_WIDTH_CHARS
            case .propXalign:
                return GTK_EDITABLE_PROP_XALIGN
            case .propEnableUndo:
                return GTK_EDITABLE_PROP_ENABLE_UNDO
            case .numProperties:
                return GTK_EDITABLE_NUM_PROPERTIES
        }
    }
}
