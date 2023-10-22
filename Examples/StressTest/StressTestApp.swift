import GtkBackend
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
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.StressTestApp"

    let state = StressTestState()

    let windowProperties = WindowProperties(
        title: "StressTestApp",
        defaultSize: WindowProperties.Size(400, 400),
        resizable: true
    )

    var body: some View {
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
}
