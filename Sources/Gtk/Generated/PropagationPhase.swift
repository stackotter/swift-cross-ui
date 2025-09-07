import CGtk

/// Describes the stage at which events are fed into a [class@EventController].
public enum PropagationPhase: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPropagationPhase

    /// Events are not delivered.
    case none
    /// Events are delivered in the capture phase. The
    /// capture phase happens before the bubble phase, runs from the toplevel down
    /// to the event widget. This option should only be used on containers that
    /// might possibly handle events before their children do.
    case capture
    /// Events are delivered in the bubble phase. The bubble
    /// phase happens after the capture phase, and before the default handlers
    /// are run. This phase runs from the event widget, up to the toplevel.
    case bubble
    /// Events are delivered in the default widget event handlers,
    /// note that widget implementations must chain up on button, motion, touch and
    /// grab broken handlers for controllers in this phase to be run.
    case target

    public static var type: GType {
        gtk_propagation_phase_get_type()
    }

    public init(from gtkEnum: GtkPropagationPhase) {
        switch gtkEnum {
            case GTK_PHASE_NONE:
                self = .none
            case GTK_PHASE_CAPTURE:
                self = .capture
            case GTK_PHASE_BUBBLE:
                self = .bubble
            case GTK_PHASE_TARGET:
                self = .target
            default:
                fatalError("Unsupported GtkPropagationPhase enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPropagationPhase {
        switch self {
            case .none:
                return GTK_PHASE_NONE
            case .capture:
                return GTK_PHASE_CAPTURE
            case .bubble:
                return GTK_PHASE_BUBBLE
            case .target:
                return GTK_PHASE_TARGET
        }
    }
}
