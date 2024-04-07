import SelectedBackend
import SwiftCrossUI

class ControlsState: Observable {
    @Observed var count = 0
    @Observed var exampleButtonState = false
    @Observed var exampleSwitchState = false
}

@main
struct ControlsApp: App {
    typealias Backend = SelectedBackend

    let identifier = "dev.stackotter.Controls"

    let state = ControlsState()

    var body: some Scene {
        WindowGroup("ControlsApp") {
            VStack {
                VStack {
                    Text("Button")
                    Button("Click me!") {
                        state.count += 1
                    }
                    Text("Count: \(state.count)")
                }
                .padding(.bottom, 20)

                VStack {
                    Text("Toggle button")
                    Toggle("Toggle me!", active: state.$exampleButtonState)
                        .toggleStyle(.button)
                    Text("Currently enabled: \(state.exampleButtonState)")
                }
                .padding(.bottom, 20)

                VStack {
                    Text("Toggle switch")
                    Toggle("Toggle me:", active: state.$exampleSwitchState)
                        .toggleStyle(.switch)
                    Text("Currently enabled: \(state.exampleSwitchState)")
                }
            }
        }
    }
}
