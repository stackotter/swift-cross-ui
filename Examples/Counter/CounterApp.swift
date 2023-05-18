import SwiftCrossUI

class Nested: Observable {
    @Observed
    var count = 0
}

class CounterState: Observable {
    @Observed
    var nested = Nested()
}

@main
struct CounterApp: App {
    let identifier = "dev.stackotter.CounterApp"

    let state = CounterState()

    let windowProperties = WindowProperties(title: "CounterApp", resizable: true)

    var body: some ViewContent {
        HStack {
            Button("-") { state.nested.count -= 1 }
            Text("Count: \(state.nested.count)")
            Button("+") { state.nested.count += 1 }
        }
    }
}
