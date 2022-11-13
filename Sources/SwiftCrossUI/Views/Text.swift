/// A text view.
public struct Text: View {
    /// The string to be shown in the text view.
    public var string: String

    public var body = EmptyViewContent()

    /// Creates a new text view with the given content.
    public init(_ string: String) {
        self.string = string
    }

    public func asWidget(_ children: EmptyViewContent.Children) -> GtkLabel {
        let widget = GtkLabel(text: string)
        return widget
    }

    public func update(_ widget: GtkLabel, children: EmptyViewContent.Children) {
        widget.text = string
    }
}
