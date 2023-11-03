import GtkBackend
import SwiftCrossUI

class ControlsState: Observable {
    @Observed var count = 0
    @Observed var exampleButtonState = false
}

@main
struct ControlsApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.Controls"

    let state = ControlsState()

    let windowProperties = WindowProperties(title: "ControlsApp", resizable: true)

    var body: some View {
        VStack(spacing: 5) {
            Text("Button")
            Button("Click me!") {
                state.count += 1
            }
            Text("Count: \(state.count)", wrap: false)
            Spacer()
                .padding(.bottom, 15)
            Text("Toggle (Button Style)")
            Toggle("Toggle me!", active: state.$exampleButtonState)
            Text("Currently enabled: \(state.exampleButtonState)")
        }
        .padding(10)
    }
}
