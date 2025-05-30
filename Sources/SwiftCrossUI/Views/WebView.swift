import Foundation

@available(tvOS, unavailable)
public struct WebView: ElementaryView {
    @State var currentURL: URL?
    @Binding var url: URL

    public init(_ url: Binding<URL>) {
        _url = url
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createWebView()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SizeProposal,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let idealSize = SIMD2(10, 10)
        let size = proposedSize.evaluated(withIdealSize: idealSize)
        return ViewLayoutResult(
            size: ViewSize(
                size: size,
                idealSize: idealSize,
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            ),
            childResults: []
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        if url != currentURL {
            backend.navigateWebView(widget, to: url)
            currentURL = url
        }
        backend.updateWebView(widget, environment: environment) { destination in
            currentURL = destination
            url = destination
        }
        backend.setSize(of: widget, to: layout.size.size)
    }
}
