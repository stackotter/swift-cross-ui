import CGtk3

public enum ScrollStep: GValueRepresentableEnum {
    public typealias GtkEnum = GtkScrollStep

    /// Scroll in steps.
    case steps
    /// Scroll by pages.
    case pages
    /// Scroll to ends.
    case ends
    /// Scroll in horizontal steps.
    case horizontalSteps
    /// Scroll by horizontal pages.
    case horizontalPages
    /// Scroll to the horizontal ends.
    case horizontalEnds

    public static var type: GType {
        gtk_scroll_step_get_type()
    }

    public init(from gtkEnum: GtkScrollStep) {
        switch gtkEnum {
            case GTK_SCROLL_STEPS:
                self = .steps
            case GTK_SCROLL_PAGES:
                self = .pages
            case GTK_SCROLL_ENDS:
                self = .ends
            case GTK_SCROLL_HORIZONTAL_STEPS:
                self = .horizontalSteps
            case GTK_SCROLL_HORIZONTAL_PAGES:
                self = .horizontalPages
            case GTK_SCROLL_HORIZONTAL_ENDS:
                self = .horizontalEnds
            default:
                fatalError("Unsupported GtkScrollStep enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkScrollStep {
        switch self {
            case .steps:
                return GTK_SCROLL_STEPS
            case .pages:
                return GTK_SCROLL_PAGES
            case .ends:
                return GTK_SCROLL_ENDS
            case .horizontalSteps:
                return GTK_SCROLL_HORIZONTAL_STEPS
            case .horizontalPages:
                return GTK_SCROLL_HORIZONTAL_PAGES
            case .horizontalEnds:
                return GTK_SCROLL_HORIZONTAL_ENDS
        }
    }
}
