import CGtk3

/// Kinds of widget-specific help. Used by the ::show-help signal.
public enum WidgetHelpType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkWidgetHelpType

    /// Tooltip.
    case tooltip
    /// What’s this.
    case whatsThis

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkWidgetHelpType) {
        switch gtkEnum {
            case GTK_WIDGET_HELP_TOOLTIP:
                self = .tooltip
            case GTK_WIDGET_HELP_WHATS_THIS:
                self = .whatsThis
            default:
                fatalError("Unsupported GtkWidgetHelpType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkWidgetHelpType {
        switch self {
            case .tooltip:
                return GTK_WIDGET_HELP_TOOLTIP
            case .whatsThis:
                return GTK_WIDGET_HELP_WHATS_THIS
        }
    }
}
