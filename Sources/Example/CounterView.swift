import SwiftGtkUI

class CounterState: ViewState {
    @Observed var count = 0
}

struct CounterView: View {
    var state = CounterState()
    
    var body: some ViewContent {
        Button("Do nothing") {}
        
        Text("Count: \(state.count)")
        HStack {
            Button("Decrement") {
                state.count -= 1
            }
            Button("Increment") {
                state.count += 1
            }
        }
    }
}
