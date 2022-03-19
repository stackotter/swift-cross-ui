import SwiftGtkUI

struct ContentView: View {
    var model = EmptyViewModel()
    
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
