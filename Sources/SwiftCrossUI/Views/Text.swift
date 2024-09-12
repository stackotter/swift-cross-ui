/// A text view.
public struct Text: ElementaryView, View {
    /// The string to be shown in the text view.
    private var string: String

    public var flexibility: Int {
        200
    }

    /// Creates a new text view that displays a string with configurable wrapping.
    public init(_ string: String) {
        self.string = string
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createTextView()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        backend.updateTextView(widget, content: string, environment: environment)

        let size = backend.size(
            of: string,
            whenDisplayedIn: widget,
            proposedFrame: proposedSize,
            environment: environment
        )
        backend.setSize(of: widget, to: size)

        let minimumWidth = backend.size(
            of: string,
            whenDisplayedIn: widget,
            proposedFrame: SIMD2(1, proposedSize.y),
            environment: environment
        ).x
        let minimumHeight = backend.size(
            of: string,
            whenDisplayedIn: widget,
            proposedFrame: SIMD2(proposedSize.x, 1),
            environment: environment
        ).y

        return ViewUpdateResult(
            size: size,
            minimumWidth: minimumWidth == 1 ? 0 : minimumWidth,
            minimumHeight: minimumHeight
        )
    }
}
