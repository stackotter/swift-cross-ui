import CGtk3

/// Kinds of widget-specific help. Used by the ::show-help signal.
public enum WidgetHelpType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkWidgetHelpType

    /// Tooltip.
case tooltip
/// What’s this.
case whatsThis

    public static var type: GType {
    gtk_widget_help_type_get_type()
}

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

    public func toGtk() -> GtkWidgetHelpType {
        switch self {
            case .tooltip:
    return GTK_WIDGET_HELP_TOOLTIP
case .whatsThis:
    return GTK_WIDGET_HELP_WHATS_THIS
        }
    }
}