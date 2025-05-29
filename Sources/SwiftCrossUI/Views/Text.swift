/// A text view.
public struct Text: Sendable {
    /// The string to be shown in the text view.
    var string: String

    /// Creates a new text view that displays a string with configurable wrapping.
    public init(_ string: String) {
        self.string = string
    }
}

extension Text: View {
}

extension Text: ElementaryView {
    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createTextView()
    }

    public func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // TODO: Avoid this. Move it to commit
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

        return ViewLayoutResult.leafView(
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

    public func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        backend.setSize(of: widget, to: layout.size.size)
    }
}
