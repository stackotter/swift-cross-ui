import CGtk3

/// Used to customize the appearance of a #GtkToolbar. Note that
/// setting the toolbar style overrides the user’s preferences
/// for the default toolbar style.  Note that if the button has only
/// a label set and GTK_TOOLBAR_ICONS is used, the label will be
/// visible, and vice versa.
public enum ToolbarStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkToolbarStyle

    /// Buttons display only icons in the toolbar.
    case icons
    /// Buttons display only text labels in the toolbar.
    case text
    /// Buttons display text and icons in the toolbar.
    case both
    /// Buttons display icons and text alongside each
    /// other, rather than vertically stacked
    case bothHoriz

    public static var type: GType {
        gtk_toolbar_style_get_type()
    }

    public init(from gtkEnum: GtkToolbarStyle) {
        switch gtkEnum {
            case GTK_TOOLBAR_ICONS:
                self = .icons
            case GTK_TOOLBAR_TEXT:
                self = .text
            case GTK_TOOLBAR_BOTH:
                self = .both
            case GTK_TOOLBAR_BOTH_HORIZ:
                self = .bothHoriz
            default:
                fatalError("Unsupported GtkToolbarStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkToolbarStyle {
        switch self {
            case .icons:
                return GTK_TOOLBAR_ICONS
            case .text:
                return GTK_TOOLBAR_TEXT
            case .both:
                return GTK_TOOLBAR_BOTH
            case .bothHoriz:
                return GTK_TOOLBAR_BOTH_HORIZ
        }
    }
}
