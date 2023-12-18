import CGtk

/// Describes how the border of a UI element should be rendered.
public enum BorderStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkBorderStyle

    /// No visible border
    case none
    /// Same as %GTK_BORDER_STYLE_NONE
    case hidden
    /// A single line segment
    case solid
    /// Looks as if the content is sunken into the canvas
    case inset
    /// Looks as if the content is coming out of the canvas
    case outset
    /// A series of round dots
    case dotted
    /// A series of square-ended dashes
    case dashed
    /// Two parallel lines with some space between them
    case double
    /// Looks as if it were carved in the canvas
    case groove
    /// Looks as if it were coming out of the canvas
    case ridge

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkBorderStyle) {
        switch gtkEnum {
            case GTK_BORDER_STYLE_NONE:
                self = .none
            case GTK_BORDER_STYLE_HIDDEN:
                self = .hidden
            case GTK_BORDER_STYLE_SOLID:
                self = .solid
            case GTK_BORDER_STYLE_INSET:
                self = .inset
            case GTK_BORDER_STYLE_OUTSET:
                self = .outset
            case GTK_BORDER_STYLE_DOTTED:
                self = .dotted
            case GTK_BORDER_STYLE_DASHED:
                self = .dashed
            case GTK_BORDER_STYLE_DOUBLE:
                self = .double
            case GTK_BORDER_STYLE_GROOVE:
                self = .groove
            case GTK_BORDER_STYLE_RIDGE:
                self = .ridge
            default:
                fatalError("Unsupported GtkBorderStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkBorderStyle {
        switch self {
            case .none:
                return GTK_BORDER_STYLE_NONE
            case .hidden:
                return GTK_BORDER_STYLE_HIDDEN
            case .solid:
                return GTK_BORDER_STYLE_SOLID
            case .inset:
                return GTK_BORDER_STYLE_INSET
            case .outset:
                return GTK_BORDER_STYLE_OUTSET
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
