import GtkBackend
import SwiftCrossUI

class CounterState: Observable {
    @Observed var count = 0
}

@main
struct CounterApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.CounterApp"

    let state = CounterState()

    let windowProperties = WindowProperties(title: "CounterApp", resizable: true)

    var body: some Scene {
        WindowGroup {
            HStack(spacing: 20) {
                Button("-") { state.count -= 1 }
                Text("Count: \(state.count)", wrap: false)
                Button("+") { state.count += 1 }
            }
            .padding(10)
        }
    }
}
