import CGtk

/// Describes the stage at which events are fed into a `GtkEventController`.
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.PropagationPhase.html)
public enum PropagationPhase {
    /// Events are not delivered automatically. Those can be manually fed through
    /// gtk_event_controller_handle_event(). This should only be used when full control about when,
    /// or whether the controller handles the event is needed.
    case none
    /// Events are delivered in the capture phase. The capture phase happens before the bubble
    /// phase, runs from the toplevel down to the event widget. This option should only be used on
    /// containers that might possibly handle events before their children do.
    case capture
    /// Events are delivered in the bubble phase. The bubble phase happens after the capture phase,
    /// and before the default handlers are run. This phase runs from the event widget, up to the
    /// toplevel.
    case bubble
    /// Events are delivered in the default widget event handlers, note that widget implementations
    /// must chain up on button, motion, touch and grab broken handlers for controllers in this
    /// phase to be run.
    case target

    func toGtkPropagationPhase() -> GtkPropagationPhase {
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

extension GtkPropagationPhase {
    func toPropagationPhase() -> PropagationPhase {
        switch self {
            case GTK_PHASE_NONE:
                return PropagationPhase.none
            case GTK_PHASE_CAPTURE:
                return .capture
            case GTK_PHASE_BUBBLE:
                return .bubble
            case GTK_PHASE_TARGET:
                return .target
            default:
                fatalError("Unsupported GtkPropagationPhase enum value: \(self.rawValue)")
        }
    }
}
