import Foundation
import GtkBackend
import SwiftCrossUI

class WindowPropertiesAppState: Observable {
    @Observed var title = "My window"
    @Observed var resizable = false
}

@main
struct WindowPropertiesApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.WindowPropertiesApp"

    let state = WindowPropertiesAppState()

    var body: some Scene {
        WindowGroup(state.title) {
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
        .defaultSize(width: 500, height: 500)
        .windowResizability(state.resizable ? .contentMinSize : .contentSize)

        WindowGroup("Secondary window") {
            Text("This a secondary window!")
                .padding(10)
        }
        .defaultSize(width: 200, height: 200)
        .windowResizability(.contentSize)
    }
}
