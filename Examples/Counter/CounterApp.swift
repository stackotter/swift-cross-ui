import SwiftCrossUI

class CounterState: Observable {
    @Observed
    var count = 0
}

@main
struct CounterApp: App {
    let identifier = "dev.stackotter.CounterApp"

    let state = CounterState()

    let windowProperties = WindowProperties(title: "CounterApp", resizable: true)

    var body: some ViewContent {
        HStack(spacing: 20) {
            Button("-") { state.count -= 1 }
            Text("Count: \(state.count)")
            Button("+") { state.count += 1 }
        }
        .padding(10)
    }
}
