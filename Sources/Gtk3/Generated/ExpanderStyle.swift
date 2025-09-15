import CGtk3

/// Used to specify the style of the expanders drawn by a #GtkTreeView.
public enum ExpanderStyle: GValueRepresentableEnum {
    public typealias GtkEnum = GtkExpanderStyle

    /// The style used for a collapsed subtree.
    case collapsed
    /// Intermediate style used during animation.
    case semiCollapsed
    /// Intermediate style used during animation.
    case semiExpanded
    /// The style used for an expanded subtree.
    case expanded

    public static var type: GType {
        gtk_expander_style_get_type()
    }

    public init(from gtkEnum: GtkExpanderStyle) {
        switch gtkEnum {
            case GTK_EXPANDER_COLLAPSED:
                self = .collapsed
            case GTK_EXPANDER_SEMI_COLLAPSED:
                self = .semiCollapsed
            case GTK_EXPANDER_SEMI_EXPANDED:
                self = .semiExpanded
            case GTK_EXPANDER_EXPANDED:
                self = .expanded
            default:
                fatalError("Unsupported GtkExpanderStyle enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkExpanderStyle {
        switch self {
            case .collapsed:
                return GTK_EXPANDER_COLLAPSED
            case .semiCollapsed:
                return GTK_EXPANDER_SEMI_COLLAPSED
            case .semiExpanded:
                return GTK_EXPANDER_SEMI_EXPANDED
            case .expanded:
                return GTK_EXPANDER_EXPANDED
        }
    }
}
