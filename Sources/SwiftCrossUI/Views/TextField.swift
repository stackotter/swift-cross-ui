/// A button view.
public struct TextField: View {
    public var body = EmptyViewContent()

    /// The label to show when the field is empty.
    private var placeholder: String
    /// Storage for the field's content.
    private var value: Binding<String>?

    /// Creates a new button.
    public init(_ placeholder: String = "", _ value: Binding<String>? = nil) {
        self.placeholder = placeholder
        self.value = value
    }

    public func asWidget(_ children: EmptyViewContent.Children) -> GtkEntry {
        return GtkEntry()
    }

    public func update(_ widget: GtkEntry, children: EmptyViewContent.Children) {
        widget.placeholder = placeholder
        widget.text = value?.wrappedValue ?? widget.text
        widget.changed = { widget in
            self.value?.wrappedValue = widget.text
        }
    }
}
