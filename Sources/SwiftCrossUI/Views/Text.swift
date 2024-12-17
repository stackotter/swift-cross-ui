/// A text view.
public struct Text: ElementaryView, View {
    /// The string to be shown in the text view.
    var string: String

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
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        // TODO: Avoid this
        // Even in dry runs we must update the underlying text view widget
        // because GtkBackend currently relies on querying the widget for text
        // properties and such (via Pango).
        backend.updateTextView(widget, content: string, environment: environment)

        let size = backend.size(
            of: string,
            whenDisplayedIn: widget,
            proposedFrame: proposedSize,
            environment: environment
        )
        if !dryRun {
            backend.setSize(of: widget, to: size)
        }

        let idealSize = backend.size(
            of: string,
            whenDisplayedIn: widget,
            proposedFrame: nil,
            environment: environment
        )

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

        return ViewUpdateResult.leafView(
            size: ViewSize(
                size: size,
                idealSize: idealSize,
                idealWidthForProposedHeight: idealSize.x,
                idealHeightForProposedWidth: size.y,
                minimumWidth: minimumWidth == 1 ? 0 : minimumWidth,
                minimumHeight: minimumHeight,
                maximumWidth: Double(idealSize.x),
                maximumHeight: Double(size.y)
            )
        )
    }
}
