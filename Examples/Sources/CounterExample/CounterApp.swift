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
            VStack {
                // ScrollView {
                    HStack {
                        Color.orange.frame(width: 5)

                        Text("Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.")
                    //     .padding()
                    }
                    .background(Color.gray)
                    .fixedSize(horizontal: false, vertical: true)
                // }
            }
            // #hotReloadable {
            //     VStack {
            //         HStack(spacing: 20) {
            //             Button("-") {
            //                 count -= 1
            //             }
            //             Text("Count: \(count)")
            //             Button("+") {
            //                 count += 1
            //             }
            //         }
            //         .padding()
            //     }
            // }
        }
        .defaultSize(width: 400, height: 200)
    }
}
