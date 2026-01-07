import CGtk

public class GSimpleAction: GAction, GObjectRepresentable {
    public var actionPointer: OpaquePointer

    public var gobjectPointer: UnsafeMutablePointer<CGtk.GObject> {
        UnsafeMutablePointer<CGtk.GObject>(actionPointer)
    }

    @GObjectProperty(named: "enabled") var enabled: Bool

    private typealias ActionHandler =
    @convention(c) (
        UnsafeMutableRawPointer,
        OpaquePointer,
        UnsafeMutableRawPointer
    ) -> Void

    public init(name: String, action: @escaping () -> Void) {
        actionPointer = g_simple_action_new(name, nil)

        class Action {
            var action: () -> Void
            init(_ action: @escaping () -> Void) { self.action = action }
        }
        let wrappedAction = Action(action)

        let handler: ActionHandler = { _, _, data in
            let action = Unmanaged<Action>.fromOpaque(data).takeUnretainedValue()
            action.action()
        }

        g_signal_connect_data(
            UnsafeMutableRawPointer(actionPointer),
            "activate",
            gCallback(handler),
            Unmanaged<Action>.passRetained(wrappedAction).toOpaque(),
            { data, _ in
                Unmanaged<Action>.fromOpaque(data!).release()
            },
            G_CONNECT_AFTER
        )
    }

    public init(name: String, state: Bool, action: @escaping (Bool) -> Void) {
        actionPointer = g_simple_action_new_stateful(
            name,
            nil,
            g_variant_new_boolean(state.toGBoolean())
        )

        class Action {
            var action: (Bool) -> Void
            init(_ action: @escaping (Bool) -> Void) { self.action = action }
        }
        let wrappedAction = Action(action)

        let handler: ActionHandler = { actionPointer, _, data in
            // Get the current state...
            let stateVariant = g_action_get_state(OpaquePointer(actionPointer))
            let state = g_variant_get_boolean(stateVariant).toBool()

            // ...toggle it...
            let newState = !state
            g_simple_action_set_state(
                OpaquePointer(actionPointer),
                g_variant_new_boolean(newState.toGBoolean())
            )

            // ...then get the action and call it with the new state.
            let action = Unmanaged<Action>.fromOpaque(data).takeUnretainedValue()
            action.action(newState)
        }

        g_signal_connect_data(
            UnsafeMutableRawPointer(actionPointer),
            "activate",
            gCallback(handler),
            Unmanaged<Action>.passRetained(wrappedAction).toOpaque(),
            { data, _ in
                Unmanaged<Action>.fromOpaque(data!).release()
            },
            G_CONNECT_AFTER
        )
    }
}
