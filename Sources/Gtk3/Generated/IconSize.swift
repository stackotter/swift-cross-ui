import CGtk3

/// Built-in stock icon sizes.
public enum IconSize: GValueRepresentableEnum {
    public typealias GtkEnum = GtkIconSize

    /// Invalid size.
    case invalid
    /// Size appropriate for menus (16px).
    case menu
    /// Size appropriate for small toolbars (16px).
    case smallToolbar
    /// Size appropriate for large toolbars (24px)
    case largeToolbar
    /// Size appropriate for buttons (16px)
    case button
    /// Size appropriate for drag and drop (32px)
    case dnd
    /// Size appropriate for dialogs (48px)
    case dialog

    public static var type: GType {
        gtk_icon_size_get_type()
    }

    public init(from gtkEnum: GtkIconSize) {
        switch gtkEnum {
            case GTK_ICON_SIZE_INVALID:
                self = .invalid
            case GTK_ICON_SIZE_MENU:
                self = .menu
            case GTK_ICON_SIZE_SMALL_TOOLBAR:
                self = .smallToolbar
            case GTK_ICON_SIZE_LARGE_TOOLBAR:
                self = .largeToolbar
            case GTK_ICON_SIZE_BUTTON:
                self = .button
            case GTK_ICON_SIZE_DND:
                self = .dnd
            case GTK_ICON_SIZE_DIALOG:
                self = .dialog
            default:
                fatalError("Unsupported GtkIconSize enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkIconSize {
        switch self {
            case .invalid:
                return GTK_ICON_SIZE_INVALID
            case .menu:
                return GTK_ICON_SIZE_MENU
            case .smallToolbar:
                return GTK_ICON_SIZE_SMALL_TOOLBAR
            case .largeToolbar:
                return GTK_ICON_SIZE_LARGE_TOOLBAR
            case .button:
                return GTK_ICON_SIZE_BUTTON
            case .dnd:
                return GTK_ICON_SIZE_DND
            case .dialog:
                return GTK_ICON_SIZE_DIALOG
        }
    }
}
