/// A container that presents rows of data arranged in columns.
// public struct Table<Row>: ElementaryView, View {
//     /// The row data to display.
//     private var rows: [Row]
//     /// The columns to display (which each compute their cell values when given
//     /// ``Table/Row`` instances).
//     private var columns: [TableColumn<Row>]

//     /// Creates a table that computes its cell values based on a collection of rows.
//     public init(_ rows: [Row], @TableBuilder<Row> _ columns: () -> [TableColumn<Row>]) {
//         self.rows = rows
//         self.columns = columns()
//     }

//     public func asWidget<Backend: AppBackend>(
//         backend: Backend
//     ) -> Backend.Widget {
//         return backend.createTable(rows: rows.count + 1, columns: columns.count)
//     }

//     public func update<Backend: AppBackend>(
//         _ widget: Backend.Widget,
//         backend: Backend
//     ) {
//         backend.setRowCount(ofTable: widget, to: rows.count + 1)
//         backend.setColumnCount(ofTable: widget, to: columns.count)
//         for (i, column) in columns.enumerated() {
//             let textView = backend.createTextView()
//             backend.updateTextView(textView, content: column.title, shouldWrap: false)
//             backend.setCell(
//                 at: CellPosition(0, i),
//                 inTable: widget,
//                 to: textView
//             )
//         }
//         for (i, row) in rows.enumerated() {
//             for (j, column) in columns.enumerated() {
//                 let textView = backend.createTextView()
//                 backend.updateTextView(textView, content: column.value(row), shouldWrap: false)
//                 backend.setCell(
//                     at: CellPosition(i + 1, j),
//                     inTable: widget,
//                     to: textView
//                 )
//             }
//         }
//     }
// }
