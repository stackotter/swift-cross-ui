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

    let windowProperties = WindowProperties(title: "Random Number Generator", defaultSize: .init(500, 0))

    var body: some ViewContent {
        VStack {
            Text("Random Number: \(state.randomNumber)")
            Button("Generate") {
                state.randomNumber = Int.random(in: Int(state.minNum)...Int(state.maxNum))
            }

            Text("Minimum:")
            Slider(
                state.$minNum.onChange { newValue in
                    if newValue > state.maxNum {
                        state.minNum = state.maxNum
                    }
                },
                minimum: 0,
                maximum: 100
            )

            Text("Maximum:")
            Slider(
                state.$maxNum.onChange { newValue in
                    if newValue < state.minNum {
                        state.maxNum = state.minNum
                    }
                },
                minimum: 0,
                maximum: 100
            )
        }
        .padding(10)
        .foregroundColor(.magenta)
    }
}

