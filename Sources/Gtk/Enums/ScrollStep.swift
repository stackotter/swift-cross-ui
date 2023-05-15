import CGtk

/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ScrollStep.html)
public enum ScrollStep {
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

    func toGtkScrollStep() -> GtkScrollStep {
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

extension GtkScrollStep {
    func toScrollStep() -> ScrollStep {
        switch self {
        case GTK_SCROLL_STEPS:
            return .steps
        case GTK_SCROLL_PAGES:
            return .pages
        case GTK_SCROLL_ENDS:
            return .ends
        case GTK_SCROLL_HORIZONTAL_STEPS:
            return .horizontalSteps
        case GTK_SCROLL_HORIZONTAL_PAGES:
            return .horizontalPages
        case GTK_SCROLL_HORIZONTAL_ENDS:
            return .horizontalEnds
        default:
            fatalError("Unsupported GtkScrollStep enum value: \(self.rawValue)")
        }
    }
}
