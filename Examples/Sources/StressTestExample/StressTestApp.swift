import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct StressTestApp: App {
    static let options: [String] = [
        "red",
        "green",
        "blue",
        "tower",
        "power",
        "flower",
        "one",
        "two",
        "three",
        "foo",
        "bar",
        "baz",
    ]

    @State var tab = 0

    @State var values: [Int: [String]] = [:]

    var body: some Scene {
        WindowGroup("Stress Tester") {
            #hotReloadable {
                NavigationSplitView {
                    VStack {
                        Button("List 1") { tab = 0 }
                        Button("List 2") { tab = 1 }
                    }.padding(10)
                } detail: {
                    VStack {
                        Button("Generate") {
                            var values: [String] = []
                            for _ in 0..<1000 {
                                values.append(Self.options.randomElement()!)
                            }

                            self.values[tab] = values
                        }
                        if let values = values[tab] {
                            ScrollView {
                                ForEach(values) { value in
                                    Text(value)
                                }
                            }.frame(minWidth: 300)
                        }
                    }.padding(10)
                }
            }
        }
        .defaultSize(width: 400, height: 400)
    }
}
