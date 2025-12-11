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
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // Avoid evaluating the binding multiple times
        let content = text

        let size: ViewSize
        if proposedSize == .unspecified {
            size = ViewSize(10, 10)
        } else if let width = proposedSize.width, proposedSize.height == nil {
            let idealHeight = backend.size(
                of: content,
                whenDisplayedIn: widget,
                proposedFrame: SIMD2(LayoutSystem.roundSize(width), 1),
                environment: environment
            ).y
            size = ViewSize(
                width,
                Double(idealHeight)
            )
        } else {
            size = proposedSize.replacingUnspecifiedDimensions(by: ViewSize(10, 10))
        }

        return ViewLayoutResult.leafView(size: size)
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

        backend.setSize(of: widget, to: layout.size.vector)
    }
}
