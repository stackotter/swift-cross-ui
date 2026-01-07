import CGtk

public class GMenu {
    var pointer: OpaquePointer

    public init() {
        pointer = g_menu_new()
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

    public func appendSection(label: String?, content: GMenu) {
        g_menu_append_section(
            pointer,
            label,
            UnsafeMutablePointer(content.pointer)
        )
    }
}
