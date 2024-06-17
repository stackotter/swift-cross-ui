import SelectedBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

class CounterState: Observable {
    @Observed var count = 0
}

@main
@HotReloadable
struct CounterApp: App {
    let identifier = "dev.stackotter.CounterApp"

    let state = CounterState()

    var body: some Scene {
        WindowGroup("CounterExample: \(state.count)") {
            #hotReloadable {
                HStack(spacing: 20) {
                    Button("-") { state.count -= 1 }
                    Text("Count: \(state.count)", wrap: false)
                    Button("+") { state.count += 1 }
                }
                .padding(10)
            }
        }
        .defaultSize(width: 200, height: 100)
    }
}
