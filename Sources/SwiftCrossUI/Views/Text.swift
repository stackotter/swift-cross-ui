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
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // TODO: Avoid this. Move it to commit once we figure out a solution for Gtk.
        // Even in dry runs we must update the underlying text view widget
        // because GtkBackend currently relies on querying the widget for text
        // properties and such (via Pango).
        backend.updateTextView(widget, content: string, environment: environment)

        let proposedFrame: SIMD2<Int>?
        if let width = proposedSize.width {
            proposedFrame = SIMD2(
                LayoutSystem.roundSize(width),
                // Backends don't care about our height proposal here at the moment.
                proposedSize.height.map(LayoutSystem.roundSize) ?? 1
            )
        } else {
            proposedFrame = nil
        }

        let size = backend.size(
            of: string,
            whenDisplayedIn: widget,
            proposedFrame: proposedFrame,
            environment: environment
        )

        return ViewLayoutResult.leafView(size: ViewSize(size))
    }

    public func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        backend.setSize(of: widget, to: layout.size.vector)
    }
}
