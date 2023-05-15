import CGtk

/// Defines the policy to be used in a scrollable widget when updating the scrolled window adjustments in a given orientation.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ScrollablePolicy.html)
public enum ScrollablePolicy {
    /// Scrollable adjustments are based on the minimum size.
    case minimum
    /// Scrollable adjustments are based on the natural size.
    case natural

    func toGtkScrollablePolicy() -> GtkScrollablePolicy {
        switch self {
        case .minimum:
            return GTK_SCROLL_MINIMUM
        case .natural:
            return GTK_SCROLL_NATURAL
        }
    }
}

extension GtkScrollablePolicy {
    func toScrollablePolicy() -> ScrollablePolicy {
        switch self {
        case GTK_SCROLL_MINIMUM:
            return .minimum
        case GTK_SCROLL_NATURAL:
            return .natural
        default:
            fatalError("Unsupported GtkScrollablePolicy enum value: \(self.rawValue)")
        }
    }
}
