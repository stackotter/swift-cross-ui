import CGtk

/// Describes the state of a [struct@Gdk.EventSequence] in a [class@Gesture].
public enum EventSequenceState: GValueRepresentableEnum {
    public typealias GtkEnum = GtkEventSequenceState

    /// The sequence is handled, but not grabbed.
    case none
    /// The sequence is handled and grabbed.
    case claimed
    /// The sequence is denied.
    case denied

    public static var type: GType {
        gtk_event_sequence_state_get_type()
    }

    public init(from gtkEnum: GtkEventSequenceState) {
        switch gtkEnum {
            case GTK_EVENT_SEQUENCE_NONE:
                self = .none
            case GTK_EVENT_SEQUENCE_CLAIMED:
                self = .claimed
            case GTK_EVENT_SEQUENCE_DENIED:
                self = .denied
            default:
                fatalError("Unsupported GtkEventSequenceState enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkEventSequenceState {
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
