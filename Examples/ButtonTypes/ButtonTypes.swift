import GtkBackend
import SwiftCrossUI

class ButtonTypesState: Observable {
    @Observed var count = 0
    @Observed var exampleButtonState = false
}

@main
struct ButtonTypesApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.ButtonTypes"

    let state = ButtonTypesState()

    let windowProperties = WindowProperties(title: "ButtonTypesApp", resizable: true)

    var body: some View {
        VStack(spacing: 5) {
            Text("Standard Button")
            Button("Click me!") {
                state.count += 1
            }
            Text("Count: \(state.count)", wrap: false)
            Spacer()
                .padding(.bottom, 15)
            Text("Toggle Button")
            ToggleButton("Toggle me!", active: state.$exampleButtonState)
            Text("Currently enabled: \(state.exampleButtonState)")
        }
        .padding(10)
    }
}
