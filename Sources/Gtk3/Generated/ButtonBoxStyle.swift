import CGtk3

/// Used to dictate the style that a #GtkButtonBox uses to layout the buttons it
/// contains.
public enum ButtonBoxStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkButtonBoxStyle

    /// Buttons are evenly spread across the box.
    case spread
    /// Buttons are placed at the edges of the box.
    case edge
    /// Buttons are grouped towards the start of the box,
    /// (on the left for a HBox, or the top for a VBox).
    case start
    /// Buttons are grouped towards the end of the box,
    /// (on the right for a HBox, or the bottom for a VBox).
    case end

    public static var type: GType {
        gtk_button_box_style_get_type()
    }

    public init(from gtkEnum: GtkButtonBoxStyle) {
        switch gtkEnum {
            case GTK_BUTTONBOX_SPREAD:
                self = .spread
            case GTK_BUTTONBOX_EDGE:
                self = .edge
            case GTK_BUTTONBOX_START:
                self = .start
            case GTK_BUTTONBOX_END:
                self = .end
            default:
                fatalError("Unsupported GtkButtonBoxStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkButtonBoxStyle {
        switch self {
            case .spread:
                return GTK_BUTTONBOX_SPREAD
            case .edge:
                return GTK_BUTTONBOX_EDGE
            case .start:
                return GTK_BUTTONBOX_START
            case .end:
                return GTK_BUTTONBOX_END
        }
    }
}
