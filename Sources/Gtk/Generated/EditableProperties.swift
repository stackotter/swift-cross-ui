import CGtk

/// The identifiers for [iface@Gtk.Editable] properties.
///
/// See [func@Gtk.Editable.install_properties] for details on how to
/// implement the `GtkEditable` interface.
public enum EditableProperties {
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

    /// Converts the value to its corresponding Gtk representation.
    func toGtkEditableProperties() -> GtkEditableProperties {
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

extension GtkEditableProperties {
    /// Converts a Gtk value to its corresponding swift representation.
    func toEditableProperties() -> EditableProperties {
        switch self {
            case GTK_EDITABLE_PROP_TEXT:
                return .propText
            case GTK_EDITABLE_PROP_CURSOR_POSITION:
                return .propCursorPosition
            case GTK_EDITABLE_PROP_SELECTION_BOUND:
                return .propSelectionBound
            case GTK_EDITABLE_PROP_EDITABLE:
                return .propEditable
            case GTK_EDITABLE_PROP_WIDTH_CHARS:
                return .propWidthChars
            case GTK_EDITABLE_PROP_MAX_WIDTH_CHARS:
                return .propMaxWidthChars
            case GTK_EDITABLE_PROP_XALIGN:
                return .propXalign
            case GTK_EDITABLE_PROP_ENABLE_UNDO:
                return .propEnableUndo
            case GTK_EDITABLE_NUM_PROPERTIES:
                return .numProperties
            default:
                fatalError("Unsupported GtkEditableProperties enum value: \(self.rawValue)")
        }
    }
}
