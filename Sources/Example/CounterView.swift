import Foundation
import SwiftGtkUI

class CounterModel: ViewModel {
    @Published var count = 0
}

struct CounterView: View {
    var model = CounterModel()
    
    var body: some ViewContent {
        Text("Count: \(model.count)")
        HStack {
            Button("Decrement") {
                model.count -= 1
            }
            Button("Increment") {
                model.count += 1
            }
        }
    }
}
