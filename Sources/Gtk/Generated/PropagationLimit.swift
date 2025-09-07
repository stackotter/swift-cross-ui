import CGtk

/// Describes limits of a [class@EventController] for handling events
/// targeting other widgets.
public enum PropagationLimit: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPropagationLimit

    /// Events are handled regardless of what their
    /// target is.
    case none
    /// Events are only handled if their target is in
    /// the same [iface@Native] (or widget with [property@Gtk.Widget:limit-events]
    /// set) as the event controllers widget.
    /// Note that some event types have two targets (origin and destination).
    case sameNative

    public static var type: GType {
        gtk_propagation_limit_get_type()
    }

    public init(from gtkEnum: GtkPropagationLimit) {
        switch gtkEnum {
            case GTK_LIMIT_NONE:
                self = .none
            case GTK_LIMIT_SAME_NATIVE:
                self = .sameNative
            default:
                fatalError("Unsupported GtkPropagationLimit enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPropagationLimit {
        switch self {
            case .none:
                return GTK_LIMIT_NONE
            case .sameNative:
                return GTK_LIMIT_SAME_NATIVE
        }
    }
}
