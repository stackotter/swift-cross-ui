import CGtk3

public class GSimpleActionGroup: GActionMap, GActionGroup {
    var pointer: UnsafeMutablePointer<CGtk3.GSimpleActionGroup>

    public var actionMapPointer: OpaquePointer {
        OpaquePointer(pointer)
    }

    public var actionGroupPointer: OpaquePointer {
        OpaquePointer(pointer)
    }

    public init() {
        pointer = g_simple_action_group_new()
    }
}
