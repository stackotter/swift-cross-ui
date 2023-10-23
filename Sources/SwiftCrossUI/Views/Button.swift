/// A control that initiates an action.
public struct Button: ElementaryView, View {
    /// The label to show on the button.
    private var label: String
    /// The action to be performed when the button is clicked.
    private var action: () -> Void

    /// Creates a button that displays a custom label.
    public init(_ label: String, action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createButton(label: label, action: action)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.setLabel(ofButton: widget, to: label)
        backend.setAction(ofButton: widget, to: action)
    }
}
