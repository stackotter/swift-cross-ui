import CGtk

/// Describes the state of a [struct@Gdk.EventSequence] in a [class@Gesture].
public enum EventSequenceState {
    /// The sequence is handled, but not grabbed.
    case none
    /// The sequence is handled and grabbed.
    case claimed
    /// The sequence is denied.
    case denied

    /// Converts the value to its corresponding Gtk representation.
    func toGtkEventSequenceState() -> GtkEventSequenceState {
        switch self {
            case .none:
                return GTK_EVENT_SEQUENCE_NONE
            case .claimed:
                return GTK_EVENT_SEQUENCE_CLAIMED
            case .denied:
                return GTK_EVENT_SEQUENCE_DENIED
        }
    }
}

extension GtkEventSequenceState {
    /// Converts a Gtk value to its corresponding swift representation.
    func toEventSequenceState() -> EventSequenceState {
        switch self {
            case GTK_EVENT_SEQUENCE_NONE:
                return .none
            case GTK_EVENT_SEQUENCE_CLAIMED:
                return .claimed
            case GTK_EVENT_SEQUENCE_DENIED:
                return .denied
            default:
                fatalError("Unsupported GtkEventSequenceState enum value: \(self.rawValue)")
        }
    }
}
