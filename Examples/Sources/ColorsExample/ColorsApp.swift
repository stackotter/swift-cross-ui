import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct ColorsApp: App {
    @State var count = 0

    var body: some Scene {
        WindowGroup("ColorsExample") {
            #hotReloadable {
                VStack {
                    Text("First column is .dark, second column is .light, third column is the system scheme")
                    HStack(spacing: 5) {
                        let colorStack = VStack(spacing: 5) {
                            Color.black
                            Color.blue
                            Color.brown
                            Color.gray
                            Color.green
                            Color.orange
                            Color.purple
                            Color.red
                            Color.yellow
                            Color.white
                        }

                        colorStack.preferredColorScheme(.dark)
                        colorStack.preferredColorScheme(.light)
                        colorStack
                    }
                }
                .padding()
            }
        }
        .defaultSize(width: 200, height: 400)
    }
}
