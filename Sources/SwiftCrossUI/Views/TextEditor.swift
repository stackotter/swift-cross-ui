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
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // Avoid evaluating the binding multiple times
        let content = text

        let idealHeight = backend.size(
            of: content,
            whenDisplayedIn: widget,
            proposedFrame: SIMD2(proposedSize.x, 1),
            environment: environment
        ).y
        let size = SIMD2(
            proposedSize.x,
            max(proposedSize.y, idealHeight)
        )

        return ViewLayoutResult.leafView(
            size: ViewSize(
                size: size,
                idealSize: SIMD2(10, 10),
                idealWidthForProposedHeight: 10,
                idealHeightForProposedWidth: idealHeight,
                minimumWidth: 0,
                minimumHeight: idealHeight,
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
