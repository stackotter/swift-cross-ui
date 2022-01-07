import SwiftGtkUI

struct ContentView: View {
    var body: [Component] {
        Button("Hello world")
        HStack {
            Button("Left")
            Button("Right")
        }
    }
}
