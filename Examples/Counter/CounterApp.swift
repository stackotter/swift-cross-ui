import SwiftCrossUI

#if canImport(GtkBackend)
    import GtkBackend
    typealias SelectedBackend = GtkBackend
#else
    #error("No valid backends found")
#endif

class CounterState: Observable {
    @Observed
    var count = 0
}

@main
struct CounterApp: App {
    typealias Backend = SelectedBackend

    let identifier = "dev.stackotter.CounterApp"

    let state = CounterState()

    let windowProperties = WindowProperties(title: "CounterApp", resizable: true)

    var body: some ViewContent {
        HStack(spacing: 20) {
            Button("-") { state.count -= 1 }
            Text("Count: \(state.count)", wrap: false)
            Button("+") { state.count += 1 }
        }
        .padding(10)
    }
}
