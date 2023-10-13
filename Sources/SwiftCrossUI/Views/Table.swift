/// A table view.
public struct Table<Row>: View {
    public var body = EmptyViewContent()

    private var rows: [Row]
    private var columns: [TableColumn<Row>]

    /// Creates a new text view with the given content.
    public init(_ rows: [Row], @TableBuilder<Row> _ columns: () -> [TableColumn<Row>]) {
        self.rows = rows
        self.columns = columns()
    }

    public func asWidget<Backend: AppBackend>(
        _ children: EmptyViewContent.Children,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createTable(rows: rows.count + 1, columns: columns.count)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: EmptyViewContent.Children,
        backend: Backend
    ) {
        backend.setRowCount(ofTable: widget, to: rows.count + 1)
        backend.setColumnCount(ofTable: widget, to: columns.count)
        for (i, column) in columns.enumerated() {
            backend.setCell(
                at: CellPosition(0, i),
                inTable: widget,
                to: backend.createTextView(
                    content: column.title,
                    shouldWrap: false
                )
            )
        }
        for (i, row) in rows.enumerated() {
            for (j, column) in columns.enumerated() {
                backend.setCell(
                    at: CellPosition(i + 1, j),
                    inTable: widget,
                    to: backend.createTextView(
                        content: column.value(row),
                        shouldWrap: false
                    )
                )
            }
        }
    }
}
