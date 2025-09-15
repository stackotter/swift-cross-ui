import CGtk3

/// Used for justifying the text inside a #GtkLabel widget. (See also
/// #GtkAlignment).
public enum Justification: GValueRepresentableEnum {
    public typealias GtkEnum = GtkJustification

    /// The text is placed at the left edge of the label.
    case left
    /// The text is placed at the right edge of the label.
    case right
    /// The text is placed in the center of the label.
    case center
    /// The text is placed is distributed across the label.
    case fill

    public static var type: GType {
        gtk_justification_get_type()
    }

    public init(from gtkEnum: GtkJustification) {
        switch gtkEnum {
            case GTK_JUSTIFY_LEFT:
                self = .left
            case GTK_JUSTIFY_RIGHT:
                self = .right
            case GTK_JUSTIFY_CENTER:
                self = .center
            case GTK_JUSTIFY_FILL:
                self = .fill
            default:
                fatalError("Unsupported GtkJustification enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkJustification {
        switch self {
            case .left:
                return GTK_JUSTIFY_LEFT
            case .right:
                return GTK_JUSTIFY_RIGHT
            case .center:
                return GTK_JUSTIFY_CENTER
            case .fill:
                return GTK_JUSTIFY_FILL
        }
    }
}
