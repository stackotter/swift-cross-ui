import SelectedBackend
import SwiftCrossUI

class CounterState: Observable {
    @Observed var count = 0
}

@main
struct CounterApp: App {
    typealias Backend = SelectedBackend

    let identifier = "dev.stackotter.CounterApp"

    let state = CounterState()

    var body: some Scene {
        WindowGroup("CounterExample: \(state.count)") {
            HStack(spacing: 20) {
                Button("-") { state.count -= 1 }
                Text("Count: \(state.count)", wrap: false)
                Button("+") { state.count += 1 }
            }
        }
    }
}
