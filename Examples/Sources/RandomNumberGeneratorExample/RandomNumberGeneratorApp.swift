import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

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
@HotReloadable
struct RandomNumberGeneratorApp: App {
    @State var minNum = 0
    @State var maxNum = 100
    @State var randomNumber = 0
    @State var colorOption: ColorOption? = ColorOption.red

    var body: some Scene {
        WindowGroup("Random Number Generator") {
            #hotReloadable {
                VStack {
                    Text("Random Number: \(randomNumber)")
                    Button("Generate") {
                        randomNumber = Int.random(in: Int(minNum)...Int(maxNum))
                    }

                    Text("Minimum: \(minNum)")
                    Slider(
                        $minNum.onChange { newValue in
                            if newValue > maxNum {
                                minNum = maxNum
                            }
                        },
                        minimum: 0,
                        maximum: 100
                    )

                    Text("Maximum: \(maxNum)")
                    Slider(
                        $maxNum.onChange { newValue in
                            if newValue < minNum {
                                maxNum = minNum
                            }
                        },
                        minimum: 0,
                        maximum: 100
                    )

                    HStack {
                        Text("Choose a color:")
                        Picker(of: ColorOption.allCases, selection: $colorOption)
                    }
                }
                .padding(10)
                .foregroundColor(colorOption?.color ?? .red)
            }
        }
        .defaultSize(width: 500, height: 0)
        .windowResizability(.contentMinSize)
    }
}
