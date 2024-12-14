import CGtk

public class GListModel: GObject {
    public var count: Int {
        Int(g_list_model_get_n_items(opaquePointer))
    }

    deinit {
        g_object_unref(gobjectPointer)
    }

    public subscript(_ index: Int) -> OpaquePointer {
        precondition(index >= 0 && index < count, "GListModel index out-of-bounds")
        return OpaquePointer(g_list_model_get_item(opaquePointer, guint(index)))
    }
}
