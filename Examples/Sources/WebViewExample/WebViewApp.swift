import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct WebViewApp: App {
    @State var urlInput = "https://stackotter.dev"

    @State var url = URL(string: "https://stackotter.dev")!

    var body: some Scene {
        WindowGroup("WebViewExample") {
            #hotReloadable {
                VStack {
                    HStack {
                        TextField("URL", text: $urlInput)
                        Button("Go") {
                            guard let url = URL(string: urlInput) else {
                                return  // disabled
                            }

                            self.url = url
                        }.disabled(URL(string: urlInput) == nil)
                    }
                    .padding()

                    #if !os(tvOS)
                        WebView($url)
                            .onChange(of: url) {
                                urlInput = url.absoluteString
                            }
                    #endif
                }
            }
        }
    }
}
