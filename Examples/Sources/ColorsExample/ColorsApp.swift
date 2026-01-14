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
                    Text("First row is .dark, second row is .light, third row is the system scheme")

                    let colorStack = HStack {
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
        }
    }
}
