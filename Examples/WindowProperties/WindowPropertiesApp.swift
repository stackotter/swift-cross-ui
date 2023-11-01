import Foundation
import GtkBackend
import SwiftCrossUI

class WindowPropertiesAppState: Observable {
    @Observed var count = 0
}

@main
struct WindowPropertiesApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.WindowPropertiesApp"

    let state = WindowPropertiesAppState()

    /// This example uses all available window properties to show how a window can be customized.
    let windowProperties = WindowProperties(
        title: "WindowPropertiesApp",
        defaultSize: WindowProperties.Size(500, 650),
        resizable: false
    )

    var body: some View {
        VStack {
            Text("This is a window with a custom size.")
            Text("This window also can't be resized.")
                .padding(.bottom, 10)

            Button("Click") { state.count += 1 }
            Text("Count: \(state.count)")
            Image(Bundle.module.bundleURL.appendingPathComponent("Banner.png").path)
        }.padding(10)
    }
}
