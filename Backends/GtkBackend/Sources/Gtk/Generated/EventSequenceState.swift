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

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
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
