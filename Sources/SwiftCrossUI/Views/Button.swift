/// A control that initiates an action.
public struct Button: ElementaryView, View {
    /// The label to show on the button.
    private var label: String
    /// The action to be performed when the button is clicked.
    private var action: () -> Void

    public var flexibility: Int {
        100
    }

    /// Creates a button that displays a custom label.
    public init(_ label: String, action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createButton()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        parentOrientation: Orientation,
        backend: Backend
    ) -> SIMD2<Int> {
        backend.updateButton(widget, label: label, action: action)
        return backend.naturalSize(of: widget)
    }
}
