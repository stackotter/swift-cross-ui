import Foundation
import SelectedBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

class WindowingAppState: Observable {
    @Observed var title = "My window"
    @Observed var resizable = false
}

@main
@HotReloadable
struct WindowingApp: App {
    let identifier = "dev.stackotter.WindowPropertiesApp"

    let state = WindowingAppState()

    var body: some Scene {
        WindowGroup(state.title) {
            #hotReloadable {
                VStack {
                    HStack {
                        Text("Window title:", wrap: false)
                        TextField("My window", state.$title)
                    }
                    Button(state.resizable ? "Disable resizing" : "Enable resizing") {
                        state.resizable = !state.resizable
                    }
                    Image(Bundle.module.bundleURL.appendingPathComponent("Banner.png").path)
                }
                .padding(10)
            }
        }
        .defaultSize(width: 500, height: 500)
        .windowResizability(state.resizable ? .contentMinSize : .contentSize)

        WindowGroup("Secondary window") {
            #hotReloadable {
                Text("This a secondary window!")
                    .padding(10)
            }
        }
        .defaultSize(width: 200, height: 200)
        .windowResizability(.contentSize)
    }
}
