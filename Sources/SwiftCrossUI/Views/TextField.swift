/// A control that displays an editable text interface.
public struct TextField: ElementaryView, View {
    /// The label to show when the field is empty.
    private var placeholder: String
    /// The field's content.
    private var value: Binding<String>?

    /// Creates an editable text field with a given placeholder.
    public init(_ placeholder: String = "", _ value: Binding<String>? = nil) {
        self.placeholder = placeholder
        self.value = value
    }

    public func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createTextField()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        backend.updateTextField(widget, placeholder: placeholder) { newValue in
            self.value?.wrappedValue = newValue
        }
        if let value = value?.wrappedValue, value != backend.getContent(ofTextField: widget) {
            backend.setContent(ofTextField: widget, to: value)
        }
        let naturalHeight = backend.naturalSize(of: widget).y
        let size = SIMD2(
            proposedSize.x,
            naturalHeight
        )
        backend.setSize(of: widget, to: size)
        return ViewUpdateResult(
            size: size,
            minimumWidth: 0,
            minimumHeight: naturalHeight
        )
    }
}
