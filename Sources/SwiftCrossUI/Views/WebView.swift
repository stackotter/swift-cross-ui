import Foundation

/// A web view.
@available(tvOS, unavailable)
public struct WebView: ElementaryView {
    @State var currentURL: URL?
    @Binding var url: URL

    /// Creates a web view.
    ///
    /// - Parameter url: A binding to the web view's URL.
    public init(_ url: Binding<URL>) {
        _url = url
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createWebView()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        if !dryRun {
            if url != currentURL {
                backend.navigateWebView(widget, to: url)
                currentURL = url
            }
            backend.updateWebView(widget, environment: environment) { destination in
                currentURL = destination
                url = destination
            }
            backend.setSize(of: widget, to: proposedSize)
        }

        return ViewUpdateResult(
            size: ViewSize(
                size: proposedSize,
                idealSize: SIMD2(10, 10),
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            ),
            childResults: []
        )
    }
}
