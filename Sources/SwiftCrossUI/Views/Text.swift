/// A text view.
public struct Text: ElementaryView {
    /// The string to be shown in the text view.
    private var string: String
    /// Specifies whether the text should be wrapped if wider than its container.
    private var wrap: Bool

    /// Creates a new text view that displays a string with configurable wrapping.
    public init(_ string: String, wrap: Bool = true) {
        self.string = string
        self.wrap = wrap
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createTextView(content: string, shouldWrap: wrap)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.setContent(ofTextView: widget, to: string)
        backend.setWrap(ofTextView: widget, to: wrap)
    }
}
