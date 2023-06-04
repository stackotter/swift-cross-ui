import CGtk

/// Describes limits of a [class@EventController] for handling events
/// targeting other widgets.
public enum PropagationLimit {
    /// Events are handled regardless of what their
    /// target is.
    case none
    /// Events are only handled if their target
    /// is in the same [iface@Native] as the event controllers widget. Note
    /// that some event types have two targets (origin and destination).
    case sameNative

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPropagationLimit() -> GtkPropagationLimit {
        switch self {
            case .none:
                return GTK_LIMIT_NONE
            case .sameNative:
                return GTK_LIMIT_SAME_NATIVE
        }
    }
}

extension GtkPropagationLimit {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPropagationLimit() -> PropagationLimit {
        switch self {
            case GTK_LIMIT_NONE:
                return .none
            case GTK_LIMIT_SAME_NATIVE:
                return .sameNative
            default:
                fatalError("Unsupported GtkPropagationLimit enum value: \(self.rawValue)")
        }
    }
}
