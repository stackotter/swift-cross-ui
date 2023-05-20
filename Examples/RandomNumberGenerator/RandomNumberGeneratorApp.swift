import SwiftCrossUI

class RandomNumberGeneratorState: Observable {
    @Observed var minNum = 0
    @Observed var maxNum = 100
    @Observed var randomNumber = 0

    var color: Color {
        Color(0, Float(minNum) / 100, Float(maxNum) / 100)
    }
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

            Text("(Excuse the weird colors, I'm just showing off dynamic styling)").padding(.top, 20)
        }
        .padding(10)
        .foregroundColor(state.color)
    }
}

