import CGtk

/// Used for justifying the text inside a GtkLabel widget. (See also GtkAlignment).
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.Justification.html)
public enum Justification {
    /// The text is placed at the left edge of the label.
    case left
    /// The text is placed at the right edge of the label.
    case right
    /// The text is placed in the center of the label.
    case center
    /// The text is placed is distributed across the label.
    case fill

    func toGtkJustification() -> GtkJustification {
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

extension GtkJustification {
    func toJustification() -> Justification {
        switch self {
        case GTK_JUSTIFY_LEFT:
            return .left
        case GTK_JUSTIFY_RIGHT:
            return .right
        case GTK_JUSTIFY_CENTER:
            return .center
        case GTK_JUSTIFY_FILL:
            return .fill
        default:
            fatalError("Unsupported GtkJustification enum value: \(self.rawValue)")
        }
    }
}
