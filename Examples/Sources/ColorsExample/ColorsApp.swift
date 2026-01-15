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
                            let colors: [Color.SystemAdaptive] = [
                                .blue,
                                .brown,
                                .gray,
                                .green,
                                .orange,
                                .purple,
                                .red,
                                .yellow,
                            ]

                            let colorStack = HStack(spacing: 5) {
                                ForEach(colors, id: \.self) { color in
                                    VStack {
                                        Color.system(color)
                                            .aspectRatio(1, contentMode: .fill)

                                        #if os(tvOS)
                                            Button("focus this") {}
                                        #endif
                                    }
                                }
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
