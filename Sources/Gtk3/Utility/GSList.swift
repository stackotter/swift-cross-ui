import CGtk3

public class GSList: GObject {
    public var count: Int {
        Int(g_slist_length(gobjectPointer.cast()))
    }

    public subscript(_ index: Int) -> OpaquePointer {
        precondition(index >= 0 && index < count, "GListModel index out-of-bounds")
        return UnsafePointer<OpaquePointer>(
            OpaquePointer(
                g_slist_nth(gobjectPointer.cast(), guint(index))
            )
        )!.pointee
    }
}
