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

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createTextField(
            content: value?.wrappedValue ?? "",
            placeholder: placeholder,
            onChange: { newValue in
                self.value?.wrappedValue = newValue
            }
        )
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.setPlaceholder(ofTextField: widget, to: placeholder)
        if let value = value?.wrappedValue, value != backend.getContent(ofTextField: widget) {
            backend.setContent(ofTextField: widget, to: value)
        }
        backend.setOnChange(ofTextField: widget) { newValue in
            self.value?.wrappedValue = newValue
        }
    }
}
