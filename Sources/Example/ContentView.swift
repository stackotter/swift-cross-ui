import SwiftGtkUI

struct ContentView: View {
    var body: some ViewContent {
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
