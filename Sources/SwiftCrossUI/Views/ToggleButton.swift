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

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createToggle()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // TODO: Implement toggle button sizing within SwiftCrossUI so that we
        //   can delay updating the underlying widget until `commit`.
        backend.setState(ofToggle: widget, to: active.wrappedValue)
        backend.updateToggle(widget, label: label, environment: environment) { newActiveState in
            active.wrappedValue = newActiveState
        }
        return ViewLayoutResult.leafView(
            size: ViewSize(fixedSize: backend.naturalSize(of: widget))
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {}
}
