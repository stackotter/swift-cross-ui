import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct ControlsApp: App {
    @State var count = 0
    @State var exampleButtonState = false
    @State var exampleSwitchState = false
    @State var sliderValue = 5.0

    var body: some Scene {
        WindowGroup("ControlsApp") {
            #hotReloadable {
                VStack {
                    VStack {
                        Text("Button")
                        Button("Click me!") {
                            count += 1
                        }
                        Text("Count: \(count)")
                    }
                    .padding(.bottom, 20)

                    VStack {
                        Text("Toggle button")
                        Toggle("Toggle me!", active: $exampleButtonState)
                            .toggleStyle(.button)
                        Text("Currently enabled: \(exampleButtonState)")
                    }
                    .padding(.bottom, 20)

                    VStack {
                        Text("Toggle switch")
                        Toggle("Toggle me:", active: $exampleSwitchState)
                            .toggleStyle(.switch)
                        Text("Currently enabled: \(exampleSwitchState)")
                    }

                    VStack {
                        Text("Slider")
                        Slider($sliderValue, minimum: 0, maximum: 10)
                            .frame(maxWidth: 200)
                        Text("Value: \(String(format: "%.02f", sliderValue))")
                    }
                }
            }
        }
    }
}
