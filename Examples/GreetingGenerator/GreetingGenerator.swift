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
            TextField("Name", state.$name)
            HStack {
                Button("Generate") {
                    state.greeting = "Hello, \(state.name)!"
                }
                Button("Reset") {
                    state.greeting = nil
                    state.name = ""
                }
            }

            if let greeting = state.greeting {
                Text(greeting).padding(.top, 10)
            }
        }
        .padding(10)
    }
}

