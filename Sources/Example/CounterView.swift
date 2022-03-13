import Foundation
import SwiftGtkUI
import OpenCombine

class CounterModel: ObservableObject {
    @Published var count = 0
}

struct CounterView: StatefulView {
    var model = CounterModel()
    
    var body: [View] {
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
