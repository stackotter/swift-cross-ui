@resultBuilder
public struct TableBuilder<Row> {
    public static func buildBlock() -> [TableColumn<Row>] {
        []
    }

    public static func buildBlock(_ components: TableColumn<Row>...) -> [TableColumn<Row>] {
        components
    }

    public static func buildArray(_ components: [TableColumn<Row>]) -> [TableColumn<Row>] {
        components
    }

    public static func buildOptional(_ component: TableColumn<Row>?) -> [TableColumn<Row>] {
        if let component = component {
            [component]
        } else {
            []
        }
    }

    public static func buildEither(first component: TableColumn<Row>) -> [TableColumn<Row>] {
        [component]
    }

    public static func buildEither(second component: TableColumn<Row>) -> [TableColumn<Row>] {
        [component]
    }
}
