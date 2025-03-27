import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct CounterApp: App {
    @State var count = 0
    @State var theme: ColorScheme = .dark

    @Environment(\.openURL) var openURL

    var body: some Scene {
        WindowGroup("CounterExample: \(count)") {
            #hotReloadable {
                ZStack {
                    theme == .dark ? Color.black : Color.white

                    VStack {
                        HStack(spacing: 20) {
                            Button("-") {
                                count -= 1
                            }
                            Text("Count: \(count)")
                            Button("+") {
                                count += 1
                            }
                        }
                        .padding()

                        Menu("Settings") {
                            Text("Current theme: \(theme)")
                            Menu("Theme") {
                                Button("Light") {
                                    theme = .light
                                }
                                Button("Dark") {
                                    theme = .dark
                                }
                            }
                            Button("Open documentation") {
                                openURL(URL(string: "https://stackotter.dev")!)
                            }
                        }
                    }
                }
                .colorScheme(.dark)
            }
        }
        .defaultSize(width: 400, height: 200)
    }
}
