/// A control for editing multiline text.
public struct TextEditor: ElementaryView {
    @Binding var text: String

    public init(text: Binding<String>) {
        _text = text
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createTextEditor()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SizeProposal,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // Avoid evaluating the binding multiple times
        let content = text

        let idealWidth = 10
        let proposal = proposedSize.evaluated(withIdealSize: SIMD2(idealWidth, 10))
        let idealHeightForWidth = backend.size(
            of: content,
            whenDisplayedIn: widget,
            proposedFrame: SIMD2(proposal.x, 1),
            environment: environment
        ).y
        let idealHeightForIdealWidth: Int
        if proposal.x == idealWidth {
            idealHeightForIdealWidth = idealHeightForWidth
        } else {
            idealHeightForIdealWidth = backend.size(
                of: content,
                whenDisplayedIn: widget,
                proposedFrame: SIMD2(10, 1),
                environment: environment
            ).y
        }
        let size = SIMD2(
            proposal.x,
            max(proposal.y, idealHeightForWidth)
        )

        return ViewLayoutResult.leafView(
            size: ViewSize(
                size: size,
                idealSize: SIMD2(idealWidth, idealHeightForIdealWidth),
                idealWidthForProposedHeight: 10,
                idealHeightForProposedWidth: idealHeightForWidth,
                minimumWidth: 0,
                minimumHeight: idealHeightForWidth,
                maximumWidth: nil,
                maximumHeight: nil
            )
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        // Avoid evaluating the binding multiple times
        let content = self.text

        backend.updateTextEditor(widget, environment: environment) { newValue in
            self.text = newValue
        }
        if text != backend.getContent(ofTextEditor: widget) {
            backend.setContent(ofTextEditor: widget, to: content)
        }

        backend.setSize(of: widget, to: layout.size.size)
    }
}
