/// A control that toggles an option.
public struct ToggleButton: ElementaryView, View {
    /// The label to show on the toggle button.
    private var label: String
    /// Whether the button is active or not.
    private var active: Binding<Bool>

    /// Creates a toggle button that displays a custom label.
    public init(_ label: String, active: Binding<Bool>) {
        self.label = label
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createToggleButton(
            label: label, 
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
        backend.setLabel(ofButton: widget, to: label)
        backend.setIsActive(ofToggleButton: widget, to: active.wrappedValue)
        backend.setOnChange(ofToggleButton: widget) { newActiveState in
            active.wrappedValue = newActiveState
        }
    }
}
