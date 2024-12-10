import CGtk3

public class GMenu {
    var pointer: OpaquePointer
    var actionMap: any GActionMap

    public init(actionMap: any GActionMap) {
        pointer = g_menu_new()
        self.actionMap = actionMap
    }

    public func appendItem(label: String, actionName: String) {
        g_menu_append(pointer, label, actionName)
    }

    public func appendSubmenu(label: String, content: GMenu) {
        g_menu_append_submenu(
            pointer,
            label,
            UnsafeMutablePointer(content.pointer)
        )
    }
}
