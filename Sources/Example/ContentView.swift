import SwiftGtkUI

struct ContentView: View {
    var body: [View] {
        Button("Hello world")
        HStack {
            Button("Left") {
                print("Pressed left")
            }
            Button("Right") {
                print("Pressed right")
            }
        }
    }
}
