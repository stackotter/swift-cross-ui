import SwiftCrossUI

class WindowPropertiesAppState: AppState {
    @Observed var count = 0
}

@main
struct WindowPropertiesApp: App {
    let identifier = "dev.stackotter.WindowPropertiesApp"
    
    let state = WindowPropertiesAppState()
    
    /// This example uses all available window properties to show how a window can be customized.
    let windowProperties = WindowProperties(title: "WindowPropertiesApp",
                                            defaultWidth: 500,
                                            defaultHeight: 650,
                                            resizable: false)
    
    var body: some ViewContent {
        HStack {
            VStack {
                Text("") /// Placeholder until .padding() is available
                Text("This is a window with a custom size.")
                Text("This window also can't be resized.")
                Text("") /// Placeholder until .padding() is available
                Button("Click") { state.count += 1 }
                Text("Count: \(state.count)")
            }
        }
    }
}
