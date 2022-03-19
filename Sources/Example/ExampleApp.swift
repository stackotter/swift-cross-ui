import SwiftGtkUI

@main
struct ExampleApp: App {
    var identifier = "dev.stackotter.SwiftGtkUIExample"
    
    var body: some ViewContent {
        ContentView()
        CounterView()
    }
}
