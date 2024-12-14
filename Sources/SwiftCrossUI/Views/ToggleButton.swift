/// A button style control that is either on or off.
struct ToggleButton: ElementaryView, View {
    /// The label to show on the toggle button.
    private var label: String
    /// Whether the button is active or not.
    private var active: Binding<Bool>

    /// Creates a toggle button that displays a custom label.
    public init(_ label: String, active: Binding<Bool>) {
        self.label = label
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createToggle()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        // TODO: Implement toggle button sizing within SwiftCrossUI so that we can properly implement `dryRun`.
        backend.updateToggle(widget, label: label) { newActiveState in
            active.wrappedValue = newActiveState
        }
        backend.setState(ofToggle: widget, to: active.wrappedValue)
        return ViewSize(fixedSize: backend.naturalSize(of: widget))
    }
}
