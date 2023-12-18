import CGtk

/// The widget attributes that can be used when creating a [class@Constraint].
public enum ConstraintAttribute: GValueRepresentableEnum {
    public typealias GtkEnum = GtkConstraintAttribute

    /// No attribute, used for constant
    /// relations
    case none
    /// The left edge of a widget, regardless of
    /// text direction
    case left
    /// The right edge of a widget, regardless
    /// of text direction
    case right
    /// The top edge of a widget
    case top
    /// The bottom edge of a widget
    case bottom
    /// The leading edge of a widget, depending
    /// on text direction; equivalent to %GTK_CONSTRAINT_ATTRIBUTE_LEFT for LTR
    /// languages, and %GTK_CONSTRAINT_ATTRIBUTE_RIGHT for RTL ones
    case start
    /// The trailing edge of a widget, depending
    /// on text direction; equivalent to %GTK_CONSTRAINT_ATTRIBUTE_RIGHT for LTR
    /// languages, and %GTK_CONSTRAINT_ATTRIBUTE_LEFT for RTL ones
    case end
    /// The width of a widget
    case width
    /// The height of a widget
    case height
    /// The center of a widget, on the
    /// horizontal axis
    case centerX
    /// The center of a widget, on the
    /// vertical axis
    case centerY
    /// The baseline of a widget
    case baseline

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkConstraintAttribute) {
        switch gtkEnum {
            case GTK_CONSTRAINT_ATTRIBUTE_NONE:
                self = .none
            case GTK_CONSTRAINT_ATTRIBUTE_LEFT:
                self = .left
            case GTK_CONSTRAINT_ATTRIBUTE_RIGHT:
                self = .right
            case GTK_CONSTRAINT_ATTRIBUTE_TOP:
                self = .top
            case GTK_CONSTRAINT_ATTRIBUTE_BOTTOM:
                self = .bottom
            case GTK_CONSTRAINT_ATTRIBUTE_START:
                self = .start
            case GTK_CONSTRAINT_ATTRIBUTE_END:
                self = .end
            case GTK_CONSTRAINT_ATTRIBUTE_WIDTH:
                self = .width
            case GTK_CONSTRAINT_ATTRIBUTE_HEIGHT:
                self = .height
            case GTK_CONSTRAINT_ATTRIBUTE_CENTER_X:
                self = .centerX
            case GTK_CONSTRAINT_ATTRIBUTE_CENTER_Y:
                self = .centerY
            case GTK_CONSTRAINT_ATTRIBUTE_BASELINE:
                self = .baseline
            default:
                fatalError("Unsupported GtkConstraintAttribute enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkConstraintAttribute {
        switch self {
            case .none:
                return GTK_CONSTRAINT_ATTRIBUTE_NONE
            case .left:
                return GTK_CONSTRAINT_ATTRIBUTE_LEFT
            case .right:
                return GTK_CONSTRAINT_ATTRIBUTE_RIGHT
            case .top:
                return GTK_CONSTRAINT_ATTRIBUTE_TOP
            case .bottom:
                return GTK_CONSTRAINT_ATTRIBUTE_BOTTOM
            case .start:
                return GTK_CONSTRAINT_ATTRIBUTE_START
            case .end:
                return GTK_CONSTRAINT_ATTRIBUTE_END
            case .width:
                return GTK_CONSTRAINT_ATTRIBUTE_WIDTH
            case .height:
                return GTK_CONSTRAINT_ATTRIBUTE_HEIGHT
            case .centerX:
                return GTK_CONSTRAINT_ATTRIBUTE_CENTER_X
            case .centerY:
                return GTK_CONSTRAINT_ATTRIBUTE_CENTER_Y
            case .baseline:
                return GTK_CONSTRAINT_ATTRIBUTE_BASELINE
        }
    }
}
