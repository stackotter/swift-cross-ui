import SelectedBackend
import SwiftCrossUI

class GreetingGeneratorState: Observable {
    @Observed var name = ""
    @Observed var greetings: [String] = []
}

@main
struct GreetingGeneratorApp: App {
    typealias Backend = SelectedBackend

    let identifier = "dev.stackotter.GreetingGenerator"

    let state = GreetingGeneratorState()

    var body: some Scene {
        WindowGroup("Greeting Generator") {
            VStack {
                TextField("Name", state.$name)
                HStack {
                    Button("Generate") {
                        state.greetings.append("Hello, \(state.name)!")
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

                        ScrollView {
                            ForEach(state.greetings.reversed()[1...]) { greeting in
                                Text(greeting)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .padding(10)
        }
    }
}
