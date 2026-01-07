import CGtk3

public class GSimpleAction: GAction, GObjectRepresentable {
    public var actionPointer: OpaquePointer

    public var gobjectPointer: UnsafeMutablePointer<CGtk3.GObject> {
        UnsafeMutablePointer<CGtk3.GObject>(actionPointer)
    }

    @GObjectProperty(named: "enabled") var enabled: Bool

    private class Action {
        var run: () -> Void

        init(_ action: @escaping () -> Void) {
            run = action
        }
    }

    public init(name: String, action: @escaping () -> Void) {
        actionPointer = g_simple_action_new(name, nil)

        let wrappedAction = Action(action)

        let handler:
            @convention(c) (
                UnsafeMutableRawPointer,
                OpaquePointer,
                UnsafeMutableRawPointer
            ) -> Void =
                { _, _, data in
                    let action = Unmanaged<Action>.fromOpaque(data)
                        .takeUnretainedValue()
                    action.run()
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

        let wrappedAction = Action(action)

        let handler:
            @convention(c) (
                UnsafeMutableRawPointer,
                OpaquePointer,
                UnsafeMutableRawPointer
            ) -> Void =
                { _, _, data in
                    let action = Unmanaged<Action>.fromOpaque(data)
                        .takeUnretainedValue()
                    action.run()
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
