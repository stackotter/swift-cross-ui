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
        return backend.createTable(rows: rows.count, columns: columns.count)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: EmptyViewContent.Children,
        backend: Backend
    ) {
        backend.setRowCount(ofTable: widget, to: rows.count)
        backend.setColumnCount(ofTable: widget, to: columns.count)
        for i in 0..<rows.count {
            let row = rows[i]
            for j in 0..<columns.count {
                backend.setCell(
                    at: CellPosition(i, j),
                    inTable: widget,
                    to: backend.createTextView(
                        content: columns[j].value(row),
                        shouldWrap: false
                    )
                )
            }
        }
    }
}
