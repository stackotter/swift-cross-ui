import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct GreetingGeneratorApp: App {
    @State var name = ""
    @State var greetings: [String] = []

    var body: some Scene {
        WindowGroup("Greeting Generator") {
            #hotReloadable {
                VStack {
                    TextField("Name", text: $name)
                    HStack {
                        Button("Generate") {
                            greetings.append("Hello, \(name)!")
                        }
                        Button("Reset") {
                            greetings = []
                            name = ""
                        }
                    }

                    if let latest = greetings.last {
                        Text(latest)
                            .padding(.top, 5)

                        if greetings.count > 1 {
                            Text("History:")
                                .padding(.top, 20)

                            ScrollView {
                                ForEach(greetings.reversed()[1...]) { greeting in
                                    Text(greeting)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                .padding(10)
            }
        }
    }
}
