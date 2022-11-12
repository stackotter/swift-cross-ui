import SwiftCrossUI

class GreetingGeneratorState: AppState {
    @Observed var name = ""
    @Observed var greeting: String?
}

@main
struct GreetingGeneratorApp: App {
    let identifier = "dev.stackotter.GreetingGenerator"

    let state = GreetingGeneratorState()

    let windowProperties = WindowProperties(title: "Greeting Generator")

    var body: some ViewContent {
        VStack {
            Text("")

            TextField("Name", state.$name)
            Button("Generate") {
                state.greeting = "Hello, \(state.name)!"
            }

            if let greeting = state.greeting {
                Text(greeting)
            }

            Text("") // Placeholder until .padding() is available
        }
    }
}

