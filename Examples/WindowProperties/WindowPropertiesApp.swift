import SwiftCrossUI

class WindowPropertiesAppState: AppState {
    @Observed var count = 0
}

@main
struct WindowPropertiesApp: App {
    let identifier = "dev.stackotter.WindowPropertiesApp"

    let state = WindowPropertiesAppState()

    /// This example uses all available window properties to show how a window can be customized.
    let windowProperties = WindowProperties(
        title: "WindowPropertiesApp",
        defaultSize: WindowProperties.Size(500, 650),
        resizable: false
    )

    var body: some ViewContent {
        HStack {
            VStack {
                Text("This is a window with a custom size.")
                Text("This window also can't be resized.")
                    .padding(.bottom, 10)

                Button("Click") { state.count += 1 }
                Text("Count: \(state.count)")
            }.padding(10)
        }
    }
}
