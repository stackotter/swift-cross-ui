import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct DatePickerApp: App {
    @State var date = Date()
    @State var style: DatePickerStyle? = .automatic

    @Environment(\.supportedDatePickerStyles) var allStyles: [DatePickerStyle]

    var body: some Scene {
        WindowGroup("Date Picker") {
            #hotReloadable {
                VStack {
                    Text("Selected date: \(date)")

                    Picker(of: allStyles, selection: $style)

                    DatePicker(
                        "Test Picker",
                        selection: $date
                    )
                    .datePickerStyle(style ?? .automatic)

                    Button("Reset date to now") {
                        date = Date()
                    }
                }
            }
        }
    }
}
