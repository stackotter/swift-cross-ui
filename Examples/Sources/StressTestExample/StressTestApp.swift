import SelectedBackend
import SwiftCrossUI

class StressTestState: Observable {
    @Observed
    var tab = 0

    @Observed
    var values: [Int: [String]] = [:]

    let options: [String] = [
        "red",
        "green",
        "blue",
        "tower",
        "power",
        "flower",
        "one",
        "two",
        "three",
        "foo",
        "bar",
        "baz",
    ]
}

@main
struct StressTestApp: App {
    let identifier = "dev.stackotter.StressTestApp"

    let state = StressTestState()

    var body: some Scene {
        WindowGroup("Stress Tester") {
            NavigationSplitView {
                VStack {
                    Button("List 1") { state.tab = 0 }
                    Button("List 2") { state.tab = 1 }
                }.padding(10)
            } detail: {
                VStack {
                    Button("Generate") {
                        var values: [String] = []
                        for _ in 0..<1000 {
                            values.append(state.options.randomElement()!)
                        }

                        state.values[state.tab] = values
                    }
                    if let values = state.values[state.tab] {
                        ScrollView {
                            ForEach(values) { value in
                                Text(value)
                            }
                        }
                    }
                }.padding(10)
            }
        }
        .defaultSize(width: 400, height: 400)
    }
}
