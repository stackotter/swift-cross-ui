import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct CounterApp: App {
    @State var count = 0

    var body: some Scene {
        WindowGroup("CounterExample: \(count)") {
            #hotReloadable {
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(Font.TextStyle.allCases) { style in
                        Text("This is \(style)")
                            .font(.system(style))
                    }
                }
                // VStack(alignment: .leading, spacing: 1) {
                //     ForEach(Font.Weight.allCases) { weight in
                //         Text("This is \(weight) text")
                //             .fontWeight(weight)
                //     }
                // }
            }
        }
        .defaultSize(width: 400, height: 200)
    }
}
