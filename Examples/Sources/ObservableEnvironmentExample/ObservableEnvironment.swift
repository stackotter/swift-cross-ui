import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct ObservableEnvironmentApp: App {
    @State var observation = Observation(text: "Very curious observation", id: 1)
    @State var secondObservation = Observation(text: "Even more curious observation", id: 2)
    @State var observationToggle = false

    var body: some Scene {
        WindowGroup("ObservableEnvironment") {
            #hotReloadable {
                VStack {
                    Button("Toggle between objects") {
                        observationToggle.toggle()
                    }
                    ContentView()
                    ContentView()
                }
                .if(!observationToggle) { view in
                    view.environment(observation)
                }
                .if(observationToggle) { view in
                    view.environment(secondObservation)
                }
            }
        }
    }
}

struct ContentView: View {
    @Environment(Observation.self) var observation: Observation

    var body: some View {
        TextField(text: observation.$text)
        Text("\(observation.id)")
    }
}

@Observable
class Observation {
    var text: String

    let id: Int

    init(text: String, id: Int) {
        self.text = text
        self.id = id
    }
}
