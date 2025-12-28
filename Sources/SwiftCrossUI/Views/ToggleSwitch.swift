/// A light switch style control that is either on or off.
struct ToggleSwitch: ElementaryView, View {
    /// Whether the switch is active or not.
    private var active: Binding<Bool>

    /// Creates a switch.
    ///
    /// - Parameter active: Whether the switch is active or not.
    public init(active: Binding<Bool>) {
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createSwitch()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        if !dryRun {
            backend.updateSwitch(widget, environment: environment) { newActiveState in
                active.wrappedValue = newActiveState
            }
            backend.setState(ofSwitch: widget, to: active.wrappedValue)
        }
        return ViewUpdateResult.leafView(
            size: ViewSize(fixedSize: backend.naturalSize(of: widget))
        )
    }
}
