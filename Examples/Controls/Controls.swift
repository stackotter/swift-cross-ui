import GtkBackend
import SwiftCrossUI

class ControlsState: Observable {
    @Observed var count = 0
    @Observed var exampleButtonState = false
    @Observed var exampleSwitchState = false
}

@main
struct ControlsApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.Controls"

    let state = ControlsState()

    let windowProperties = WindowProperties(
        title: "ControlsApp",
        resizable: true
    )

    var body: some View {
        HStack {
            VStack {
                Text("Button")
                Button("Click me!") {
                    state.count += 1
                }
                Text("Count: \(state.count)", wrap: false)
                Spacer()
            }
            Spacer()
            VStack {
                Text("Toggle (Button Style)")
                Toggle("Toggle me!", active: state.$exampleButtonState)
                    .toggleStyle(.button)
                Text("Currently enabled: \(state.exampleButtonState)")
                Spacer()
                    .padding(.bottom, 10)
                Text("Toggle (Switch Style)")
                HStack {
                    Toggle("Toggle me:", active: state.$exampleSwitchState)
                        .toggleStyle(.switch)
                    Spacer()
                        .padding(.bottom, 10)
                }
                Text("Currently enabled: \(state.exampleSwitchState)")
                Spacer()
            }
        }
        .padding(10)
    }
}
