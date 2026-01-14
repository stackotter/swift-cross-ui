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

                    ScrollView(.horizontal) {
                        VStack(spacing: 5) {
                            let colorStack = HStack(spacing: 5) {
                                Color.system(.blue).aspectRatio(1, contentMode: .fill)
                                Color.system(.brown).aspectRatio(1, contentMode: .fill)
                                Color.system(.gray).aspectRatio(1, contentMode: .fill)
                                Color.system(.green).aspectRatio(1, contentMode: .fill)
                                Color.system(.orange).aspectRatio(1, contentMode: .fill)
                                Color.system(.purple).aspectRatio(1, contentMode: .fill)
                                Color.system(.red).aspectRatio(1, contentMode: .fill)
                                Color.system(.yellow).aspectRatio(1, contentMode: .fill)
                            }

                            colorStack.preferredColorScheme(.dark)
                            colorStack.preferredColorScheme(.light)
                            colorStack
                        }
                    }
                }
                .padding()
            }
        }
    }
}
