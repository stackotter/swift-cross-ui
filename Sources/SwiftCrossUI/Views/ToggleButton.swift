/// A control that toggles an option.
public struct ToggleButton: ElementaryView, View {
    /// The label to show on the toggle button.
    private var label: String
    /// The state of the button.
    private var toggled: Binding<Bool>?

    /// Creates a toggle button that displays a custom label.
    public init(_ label: String, _ toggled: Binding<Bool>? = nil) {
        self.label = label
        self.toggled = toggled
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createToggleButton(
            label: label, 
            toggled: toggled?.wrappedValue ?? false,
            onChange: { newValue in
                self.toggled?.wrappedValue = newValue
            }
        )
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.setLabel(ofButton: widget, to: label)
        if let toggled = toggled?.wrappedValue, toggled != backend.getToggled(ofToggleButton: widget) {

        }
        backend.setOnToggled(
            ofToggleButton: widget, 
            to: toggled
        )
    }
}
