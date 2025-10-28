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
    @State var exampleCheckboxState = false
    @State var sliderValue = 5.0
    @State var text = ""
    @State var flavor: String? = nil
    @State var enabled = true
    @State var progressViewSize: Int = 10
    @State var isProgressViewResizable = true

    var body: some Scene {
        WindowGroup("ControlsApp") {
            #hotReloadable {
                VStack(spacing: 30) {
                    VStack {
                        Text("Button")
                        Button("Click me!") {
                            count += 1
                        }
                        Text("Count: \(count)")
                    }
                    .padding(.bottom, 20)

                    #if !canImport(UIKitBackend)
                        VStack {
                            Text("Toggle button")
                            Toggle("Toggle me!", active: $exampleButtonState)
                                .toggleStyle(.button)
                            Text("Currently enabled: \(exampleButtonState)")
                        }
                        .padding(.bottom, 20)
                    #endif

                    VStack {
                        Text("Toggle switch")
                        Toggle("Toggle me:", active: $exampleSwitchState)
                            .toggleStyle(.switch)
                        Text("Currently enabled: \(exampleSwitchState)")
                    }

                    #if !canImport(UIKitBackend)
                        VStack {
                            Text("Checkbox")
                            Toggle("Toggle me:", active: $exampleCheckboxState)
                                .toggleStyle(.checkbox)
                            Text("Currently enabled: \(exampleCheckboxState)")
                        }
                    #endif

                    VStack {
                        Text("Slider")
                        Slider($sliderValue, minimum: 0, maximum: 10)
                            .frame(maxWidth: 200)
                        Text("Value: \(String(format: "%.02f", sliderValue))")
                    }

                    VStack {
                        Text("Text field")
                        TextField("Text field", text: $text)
                        Text("Value: \(text)")
                    }

                    Toggle("Enable ProgressView resizability", active: $isProgressViewResizable)
                    Slider($progressViewSize, minimum: 10, maximum: 100)
                    ProgressView()
                        .resizable(isProgressViewResizable)
                        .frame(width: progressViewSize, height: progressViewSize)

                    VStack {
                        Text("Drop down")
                        HStack {
                            Text("Flavor: ")
                            Picker(of: ["Vanilla", "Chocolate", "Strawberry"], selection: $flavor)
                        }
                        Text("You chose: \(flavor ?? "Nothing yet!")")
                    }
                }.padding().disabled(!enabled)

                Toggle(enabled ? "Disable all" : "Enable all", active: $enabled)
                    .padding()
            }

        }.defaultSize(width: 400, height: 600)
    }
}
