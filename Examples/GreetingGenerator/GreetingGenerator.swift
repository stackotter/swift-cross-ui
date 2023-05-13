import SwiftCrossUI

class GreetingGeneratorState: AppState {
    @Observed var name = ""
    @Observed var greetings: [String] = []
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
                    state.greetings.append("Hello, \(state.name)!")
                    state.name = ""
                }
                Button("Reset") {
                    state.greetings = []
                    state.name = ""
                }
            }

            if let latest = state.greetings.last {
                Text(latest)
                    .padding(.top, 5)

                if state.greetings.count > 1 {
                    Text("History:")
                        .padding(.top, 20)

                    ForEach(state.greetings.reversed()[1...]) { greeting in
                        Text(greeting)
                    }
                    .frame(height: 200)
                    .padding(.top, 8)
                }
            }
        }
        .padding(10)
    }
}

