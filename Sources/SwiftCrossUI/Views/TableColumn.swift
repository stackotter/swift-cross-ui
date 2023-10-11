public struct TableColumn<Row> {
    public var title: String
    public var value: (Row) -> String

    public init(_ title: String, value keyPath: KeyPath<Row, String>) {
        self.title = title
        self.value = { row in
            row[keyPath: keyPath]
        }
    }

    public init<Value: CustomStringConvertible>(
        _ title: String,
        value keyPath: KeyPath<Row, Value>
    ) {
        self.title = title
        self.value = { row in
            row[keyPath: keyPath].description
        }
    }
}
