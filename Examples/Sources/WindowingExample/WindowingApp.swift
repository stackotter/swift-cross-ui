import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct WindowingApp: App {
    @State var title = "My window"
    @State var resizable = false

    var body: some Scene {
        WindowGroup(title) {
            #hotReloadable {
                VStack {
                    HStack {
                        Text("Window title:")
                        TextField("My window", $title)
                    }
                    Button(resizable ? "Disable resizing" : "Enable resizing") {
                        resizable = !resizable
                    }
                    Image(Bundle.module.bundleURL.appendingPathComponent("Banner.png"))
                }
                .padding(10)
            }
        }
        .defaultSize(width: 500, height: 500)
        .windowResizability(resizable ? .contentMinSize : .contentSize)

        WindowGroup("Secondary window") {
            #hotReloadable {
                Text("This a secondary window!")
                    .padding(10)
            }
        }
        .defaultSize(width: 200, height: 200)
        .windowResizability(.contentMinSize)

        WindowGroup("Tertiary window") {
            #hotReloadable {
                Text("This a tertiary window!")
                    .padding(10)
            }
        }
        .defaultSize(width: 200, height: 200)
        .windowResizability(.contentMinSize)
    }
}
