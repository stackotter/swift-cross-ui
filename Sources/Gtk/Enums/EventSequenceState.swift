import CGtk

/// Describes the state of a `GdkEventSequence` in a `GtkGesture`.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.EventSequenceState.html)
public enum EventSequenceState {
    /// The sequence is handled, but not grabbed.
    case none
    /// The sequence is handled and grabbed.
    case claimed
    /// The sequence is denied.
    case denied

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
    func toEventSequenceState() -> EventSequenceState {
        switch self {
            case GTK_EVENT_SEQUENCE_NONE:
                return EventSequenceState.none
            case GTK_EVENT_SEQUENCE_CLAIMED:
                return .claimed
            case GTK_EVENT_SEQUENCE_DENIED:
                return .denied
            default:
                fatalError("Unsupported GtkEventSequenceState enum value: \(self.rawValue)")
        }
    }
}
