import SelectedBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

struct Person {
    var name: String
    var age: Int
    var phone: String
    var email: String
    var occupation: String
}

class SpreadsheetState: Observable {
    @Observed
    var data = [
        Person(
            name: "Alice", age: 99, phone: "(+61)1234123412",
            email: "alice@example.com", occupation: "developer"
        ),
        Person(
            name: "Bob", age: 99, phone: "(+61)1234123412",
            email: "bob@example.com", occupation: "adversary"
        ),
    ]
}

@main
@HotReloadable
struct SpreadsheetApp: App {
    let identifier = "dev.stackotter.SpreadsheetApp"

    let state = SpreadsheetState()

    var body: some Scene {
        WindowGroup("Spreadsheet") {
            #hotReloadable {
                Table(state.data) {
                    TableColumn("Name", value: \Person.name)
                    TableColumn("Age", value: \Person.age)
                    TableColumn("Phone", value: \Person.phone)
                    TableColumn("Email", value: \Person.email)
                    TableColumn("Occupation", value: \Person.occupation)
                }
                .padding(10)
            }
        }
    }
}
