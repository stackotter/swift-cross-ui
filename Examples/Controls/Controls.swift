import GtkBackend
import SwiftCrossUI

enum ControlCategory {
    case buttons
    case toggles
}

class ControlsState: Observable {
    @Observed var selectedCategory: ControlCategory?
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
        defaultSize: WindowProperties.Size(400, 350),
        resizable: true
    )

    var body: some View {
        NavigationSplitView {
            VStack() {
                Button("Buttons") { state.selectedCategory = .buttons }
                Button("Toggles") { state.selectedCategory = .toggles }
                Spacer()
            }.padding(10)
        } detail: {
            VStack() {
                switch state.selectedCategory {
                    case .buttons:
                        ButtonsView
                            .padding(.bottom, 10)
                    case .toggles:
                        TogglesView
                            .padding(.bottom, 10)
                    case nil:
                        Text("Select a category.")
                }
            }.padding(10)
        }
    }

    var ButtonsView: some View {
        VStack {
            Text("Button")
            Button("Click me!") {
                state.count += 1
            }
            Text("Count: \(state.count)", wrap: false)
            Spacer()
        }
    }

    var TogglesView: some View {
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
            }
            Text("Currently enabled: \(state.exampleSwitchState)")
            Spacer()
        }
    }
}
