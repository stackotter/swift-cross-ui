import CGtk

extension ListBox {
    public func append(_ child: Widget) {
        gtk_list_box_append(opaquePointer, child.widgetPointer)
    }

    public func removeAll() {
        var index = 0
        while let row = gtk_list_box_get_row_at_index(opaquePointer, gint(index)) {
            gtk_list_box_row_set_child(row, nil)
            index += 1
        }
        gtk_list_box_remove_all(opaquePointer)
    }

    /// Returns `true` on success.
    @discardableResult
    public func selectRow(at index: Int) -> Bool {
        guard let row = gtk_list_box_get_row_at_index(opaquePointer, gint(index)) else {
            return false
        }
        gtk_list_box_select_row(opaquePointer, row)
        return true
    }

    public func unselectAll() {
        gtk_list_box_unselect_all(opaquePointer)
    }
}
