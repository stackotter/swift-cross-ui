import SwiftCrossUI

class RandomNumberGeneratorState: AppState {
    @Observed var minNum = 0
    @Observed var maxNum = 100
    @Observed var randomNumber = 0
}

@main
struct RandomNumberGeneratorApp: App {
    let identifier = "dev.stackotter.RandomNumberGeneratorApp"
    let state = RandomNumberGeneratorState()
    
    var body: some ViewContent {
        VStack {
            Text("") // Placeholder until padding is available
            Text("Random Number: \(state.randomNumber)")
            Button("Generate") {
                state.randomNumber = Int.random(in: state.minNum...state.maxNum)
            }
            HStack {
                Button("-5") { state.minNum -= 5 }
                Button("-1") { state.minNum -= 1 }
                Text("Minimum: \(state.minNum)")
                Button("+1") { state.minNum += 1 }
                Button("+5") { state.minNum += 5 }
            }
            HStack {
                Button("-5") { state.maxNum -= 5 }
                Button("-1") { state.maxNum -= 1 }
                Text("Maximum: \(state.maxNum)")
                Button("+1") { state.maxNum += 1 }
                Button("+5") { state.maxNum += 5 }
            }
            Text("") // Placeholder until padding is available
        }
    }
}

