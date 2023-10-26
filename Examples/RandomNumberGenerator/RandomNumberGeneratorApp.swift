import GtkBackend
import SwiftCrossUI

class RandomNumberGeneratorState: Observable {
    @Observed var minNum = 0
    @Observed var maxNum = 100
    @Observed var randomNumber = 0
    @Observed var colorOption: ColorOption? = ColorOption.red
}

enum ColorOption: String, CaseIterable {
    case red
    case green
    case blue

    var color: Color {
        switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
        }
    }
}

@main
struct RandomNumberGeneratorApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.RandomNumberGeneratorApp"

    let state = RandomNumberGeneratorState()

    var body: some Scene {
        WindowGroup("Random Number Generator") {
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

                Text("Choose a color:")
                    .padding(.top, 20)
                Picker(of: ColorOption.allCases, selection: state.$colorOption)
            }
            .padding(10)
            .foregroundColor(state.colorOption?.color ?? .red)
        }
        .defaultSize(width: 500, height: 0)
    }
}
