/// A text view.
public struct Text: View {
    public var body = EmptyView()
    public typealias State = EmptyState
    public typealias NodeChildren = EmptyView.NodeChildren

    /// The string to be shown in the text view.
    private var string: String
    /// Specifies whether the text should be wrapped if wider than its container.
    private var wrap: Bool

    /// Creates a new text view with the given content.
    public init(_ string: String, wrap: Bool = true) {
        self.string = string
        self.wrap = wrap
    }

    public func asWidget<Backend: AppBackend>(
        _ children: [Backend.Widget],
        backend: Backend
    ) -> Backend.Widget {
        return backend.createTextView(content: string, shouldWrap: wrap)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: [Backend.Widget],
        backend: Backend
    ) {
        backend.setContent(ofTextView: widget, to: string)
        backend.setWrap(ofTextView: widget, to: wrap)
    }
}
