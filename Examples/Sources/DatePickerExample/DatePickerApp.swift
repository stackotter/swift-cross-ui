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

    var allStyles: [DatePickerStyle]

    init() {
        allStyles = [.automatic]

        if #available(iOS 14, macCatalyst 14, *) {
            allStyles.append(.graphical)
        }

        if #available(iOS 13.4, macCatalyst 13.4, *) {
            allStyles.append(.compact)
            #if os(iOS) || os(visionOS) || canImport(WinUIBackend)
                allStyles.append(.wheel)
            #endif
        }
    }

    var body: some Scene {
        WindowGroup("Date Picker") {
            VStack {
                Text("Selected date: \(date)")

                Picker(of: allStyles, selection: $style)

                DatePicker(
                    "Test Picker",
                    selection: $date
                )
                .datePickerStyle(style ?? .automatic)
            }
        }
    }
}
