/// A control that is either on or off.
public struct Switch: ElementaryView, View {
    /// Whether the switch is active or not.
    private var active: Binding<Bool>

    /// Creates a switch.
    public init(active: Binding<Bool>) {
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createSwitch(
            active: active.wrappedValue,
            onChange: { newValue in
                self.active.wrappedValue = newValue
            }
        )
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.setIsActive(ofSwitch: widget, to: active.wrappedValue)
        backend.setOnChange(ofSwitch: widget) { newActiveState in
            active.wrappedValue = newActiveState
        }
    }
}
