import CGtk

/// Defines the policy to be used in a scrollable widget when updating
/// the scrolled window adjustments in a given orientation.
public enum ScrollablePolicy: GValueRepresentableEnum {
    public typealias GtkEnum = GtkScrollablePolicy

    /// Scrollable adjustments are based on the minimum size
    case minimum
    /// Scrollable adjustments are based on the natural size
    case natural

    public static var type: GType {
        gtk_scrollable_policy_get_type()
    }

    public init(from gtkEnum: GtkScrollablePolicy) {
        switch gtkEnum {
            case GTK_SCROLL_MINIMUM:
                self = .minimum
            case GTK_SCROLL_NATURAL:
                self = .natural
            default:
                fatalError("Unsupported GtkScrollablePolicy enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkScrollablePolicy {
        switch self {
            case .minimum:
                return GTK_SCROLL_MINIMUM
            case .natural:
                return GTK_SCROLL_NATURAL
        }
    }
}
