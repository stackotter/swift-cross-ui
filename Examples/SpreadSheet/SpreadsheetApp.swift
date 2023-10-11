import GtkBackend
import SwiftCrossUI

struct Person {
    var name: String
    var age: Int
    var phone: String
    var email: String
    var occupation: String
}

class SpreadSheetState: Observable {
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
struct SpreadSheetApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.SpreadSheetApp"

    let state = SpreadSheetState()

    let windowProperties = WindowProperties(title: "SpreadSheetApp", resizable: true)

    var body: some ViewContent {
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
