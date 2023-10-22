/// A button view.
public struct Button: View {
    public var body = EmptyView()

    /// The label to show on the button.
    private var label: String
    /// The action to be performed when the button is clicked.
    private var action: () -> Void

    /// Creates a new button.
    public init(_ label: String, action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }

    public func asWidget<Backend: AppBackend>(
        _ children: [Backend.Widget],
        backend: Backend
    ) -> Backend.Widget {
        return backend.createButton(label: label, action: action)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: [Backend.Widget],
        backend: Backend
    ) {
        backend.setLabel(ofButton: widget, to: label)
        backend.setAction(ofButton: widget, to: action)
    }
}
