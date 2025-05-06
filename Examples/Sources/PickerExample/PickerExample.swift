import SwiftCrossUI
import DefaultBackend

@main
@HotReloadable
struct PickerExampleApp: App {
    let options: [String] = (0..<10).map({ "Option \($0)" })
    @State var selectedOption: String?

    init() {
        selectedOption = options.first
    }
    
    var body: some Scene {
        WindowGroup("Picker Example") {           
            VStack {
                Picker(of: options, selection: $selectedOption)
             	Text("Selected: \(selectedOption ?? "nothing")")
            }
            .padding()
        }
        .defaultSize(width: 800, height: 400)
    }
}
