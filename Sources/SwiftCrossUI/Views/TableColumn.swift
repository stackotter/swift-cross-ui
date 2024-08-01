/// A column that displays a view for each row in a table.
// public struct TableColumn<Row> {
//     public var title: String
//     public var value: (Row) -> String

//     /// Creates a labelled column that displays a string property.
//     public init(_ title: String, value keyPath: KeyPath<Row, String>) {
//         self.title = title
//         self.value = { row in
//             row[keyPath: keyPath]
//         }
//     }

//     /// Creates a labelled column that displays a string convertible property.
//     public init<Value: CustomStringConvertible>(
//         _ title: String,
//         value keyPath: KeyPath<Row, Value>
//     ) {
//         self.title = title
//         self.value = { row in
//             row[keyPath: keyPath].description
//         }
//     }
// }
