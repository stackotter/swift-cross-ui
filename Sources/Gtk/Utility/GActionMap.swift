import CGtk

public protocol GActionMap {
    var actionMapPointer: OpaquePointer { get }
}

extension GActionMap {
    public func addAction(_ action: any GAction) {
        g_action_map_add_action(actionMapPointer, action.actionPointer)
    }

    public func addAction(named name: String, action: @escaping () -> Void) {
        let simpleAction = GSimpleAction(name: name, action: action)
        addAction(simpleAction)
    }
}
