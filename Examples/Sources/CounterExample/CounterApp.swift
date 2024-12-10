import DefaultBackend
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
    let state = CounterState()

    var body: some Scene {
        WindowGroup("CounterExample: \(state.count)") {
            #hotReloadable {
                HStack(spacing: 20) {
                    Button("-") {
                        state.count -= 1
                    }
                    Text("Count: \(state.count)")
                    Button("+") {
                        state.count += 1
                    }
                }
                .padding()
            }
        }
        .defaultSize(width: 400, height: 200)
        .commands {
            CommandMenu("Help") {
                Text("Need help?")
                Button("User guide") {
                    print("User guide")
                }
                Menu("Export as...") {
                    Button("PNG") {
                        print("Export as PNG")
                    }
                    Button("JPEG") {
                        print("Export as JPEG")
                    }
                }
            }

            CommandMenu("Window") {
                Button("Maximize") {
                    print("Maximize")
                }
                Button("Minimize") {
                    print("Minimize")
                }
            }
        }
    }
}
