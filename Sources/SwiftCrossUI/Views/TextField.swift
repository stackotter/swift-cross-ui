/// A control that displays an editable text interface.
public struct TextField: ElementaryView, View {
    /// The label to show when the field is empty.
    private var placeholder: String
    /// The field's content.
    private var value: Binding<String>?

    /// Creates an editable text field with a given placeholder.
    public init(_ placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder
        self.value = text
    }

    /// Creates an editable text field with a given placeholder.
    @available(
        *, deprecated,
        message: "Use TextField(_:text:) instead",
        renamed: "TextField.init(_:text:)"
    )
    public init(_ placeholder: String = "", _ value: Binding<String>? = nil) {
        self.placeholder = placeholder
        var dummy = ""
        self.value = value ?? Binding(get: { dummy }, set: { dummy = $0 })
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        return backend.createTextField()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let naturalHeight = backend.naturalSize(of: widget).y
        let size = SIMD2(
            proposedSize.x,
            naturalHeight
        )

        // TODO: Allow backends to set their own ideal text field width
        return ViewLayoutResult.leafView(
            size: ViewSize(
                size: size,
                idealSize: SIMD2(100, naturalHeight),
                minimumWidth: 0,
                minimumHeight: naturalHeight,
                maximumWidth: nil,
                maximumHeight: Double(naturalHeight)
            )
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        backend.updateTextField(
            widget,
            placeholder: placeholder,
            environment: environment,
            onChange: { newValue in
                self.value?.wrappedValue = newValue
            },
            onSubmit: environment.onSubmit ?? {}
        )
        if let value = value?.wrappedValue, value != backend.getContent(ofTextField: widget) {
            backend.setContent(ofTextField: widget, to: value)
        }

        backend.setSize(of: widget, to: layout.size.size)
    }
}
