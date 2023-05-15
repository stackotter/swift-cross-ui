import CGtk

/// Describes how the border of a UI element should be rendered.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.BorderStyle.html)
public enum BorderStyle {
    /// No visible border.
    case none
    /// A single line segment.
    case solid
    /// Looks as if the content is sunken into the canvas.
    case inset
    /// Looks as if the content is coming out of the canvas.
    case outset
    /// Same as GTK_BORDER_STYLE_NONE.
    case hidden
    /// A series of round dots.
    case dotted
    /// A series of square-ended dashes.
    case dashed
    /// Two parallel lines with some space between them.
    case double
    /// Looks as if it were carved in the canvas.
    case groove
    /// Looks as if it were coming out of the canvas.
    case ridge

    func toGtkBorderStyle() -> GtkBorderStyle {
        switch self {
            case .none:
                return GTK_BORDER_STYLE_NONE
            case .solid:
                return GTK_BORDER_STYLE_SOLID
            case .inset:
                return GTK_BORDER_STYLE_INSET
            case .outset:
                return GTK_BORDER_STYLE_OUTSET
            case .hidden:
                return GTK_BORDER_STYLE_HIDDEN
            case .dotted:
                return GTK_BORDER_STYLE_DOTTED
            case .dashed:
                return GTK_BORDER_STYLE_DASHED
            case .double:
                return GTK_BORDER_STYLE_DOUBLE
            case .groove:
                return GTK_BORDER_STYLE_GROOVE
            case .ridge:
                return GTK_BORDER_STYLE_RIDGE
        }
    }
}

extension GtkBorderStyle {
    func toBorderStyle() -> BorderStyle {
        switch self {
            case GTK_BORDER_STYLE_NONE:
                return BorderStyle.none
            case GTK_BORDER_STYLE_SOLID:
                return .solid
            case GTK_BORDER_STYLE_INSET:
                return .inset
            case GTK_BORDER_STYLE_OUTSET:
                return .outset
            case GTK_BORDER_STYLE_HIDDEN:
                return .hidden
            case GTK_BORDER_STYLE_DOTTED:
                return .dotted
            case GTK_BORDER_STYLE_DASHED:
                return .dashed
            case GTK_BORDER_STYLE_DOUBLE:
                return .double
            case GTK_BORDER_STYLE_GROOVE:
                return .groove
            case GTK_BORDER_STYLE_RIDGE:
                return .ridge
            default:
                fatalError("Unsupported GtkBorderStyle enum value: \(self.rawValue)")
        }
    }
}
