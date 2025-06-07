/// A checkbox control that is either on or off.
struct Checkbox: ElementaryView, View {
    /// Whether the checkbox is active or not.
    private var active: Binding<Bool>

    /// Creates a checkbox.
    public init(active: Binding<Bool>) {
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createCheckbox()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        if !dryRun {
            backend.updateCheckbox(widget, environment: environment) { newActiveState in
                active.wrappedValue = newActiveState
            }
            backend.setState(ofCheckbox: widget, to: active.wrappedValue)
        }

        return ViewUpdateResult.leafView(
            size: ViewSize(fixedSize: backend.naturalSize(of: widget))
        )
    }
}
