import Foundation

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

    public func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SizeProposal,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // TODO: Avoid this. Move it to commit
        // Even in dry runs we must update the underlying text view widget
        // because GtkBackend currently relies on querying the widget for text
        // properties and such (via Pango).
        backend.updateTextView(widget, content: string, environment: environment)

        let idealSize = backend.size(
            of: string,
            whenDisplayedIn: widget,
            proposedFrame: nil,
            environment: environment
        )

        let size: SIMD2<Int>
        let minimumWidth: Int
        let minimumHeight: Int
        if let proposedSize = proposedSize.concrete {
            size = backend.size(
                of: string,
                whenDisplayedIn: widget,
                proposedFrame: proposedSize,
                environment: environment
            )
            minimumWidth =
                backend.size(
                    of: string,
                    whenDisplayedIn: widget,
                    proposedFrame: SIMD2(1, proposedSize.y),
                    environment: environment
                ).x
            minimumHeight =
                backend.size(
                    of: string,
                    whenDisplayedIn: widget,
                    proposedFrame: SIMD2(proposedSize.x, 1),
                    environment: environment
                ).y
        } else if let proposedWidth = proposedSize.width {
            size = backend.size(
                of: string,
                whenDisplayedIn: widget,
                proposedFrame: SIMD2(proposedWidth, 1),
                environment: environment
            )
            minimumWidth =
                backend.size(
                    of: string,
                    whenDisplayedIn: widget,
                    // This proposed height could really be anything. We work under
                    // the assumption that backends generally ignore height proposals
                    // during text layout.
                    proposedFrame: SIMD2(1, size.y),
                    environment: environment
                ).x
            minimumHeight = size.y
        } else {
            size = idealSize
            minimumWidth = size.x
            minimumHeight = size.y
        }

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
