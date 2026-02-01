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
    @State var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup("Random Number Generator") {
            #hotReloadable {
                ContentView()
                    .environment(viewModel)
            }
        }
        .defaultSize(width: 500, height: 0)
        .windowResizability(.contentMinSize)
    }
}

struct ContentView: View {
    @Environment(ViewModel.self) var vm
    var body: some View {
        VStack {
            Text("Random Number: \(vm.randomNumber)")
            Button("Generate") {
                vm.randomNumber = Int.random(in: Int(vm.minNum)...Int(vm.maxNum))
            }

            Text("Minimum: \(vm.minNum)")
            Slider(
                value: vm.$minNum.onChange { newValue in
                    if newValue > vm.maxNum {
                        vm.minNum = vm.maxNum
                    }
                },
                in: 0...100
            )

            Text("Maximum: \(vm.maxNum)")
            Slider(
                value: vm.$maxNum.onChange { newValue in
                    if newValue < vm.minNum {
                        vm.maxNum = vm.minNum
                    }
                },
                in: 0...100
            )

            HStack {
                Text("Choose a color:")
                Picker(of: ColorOption.allCases, selection: vm.$colorOption)
            }
        }
        .padding(10)
        .foregroundColor(vm.colorOption?.color ?? .red)
    }
}

@ObservableObject
class ViewModel {
    var minNum = 0
    var maxNum = 100
    var randomNumber = 0
    var colorOption: ColorOption? = ColorOption.red
}
