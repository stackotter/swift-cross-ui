/// An action that opens a window with the specified ID.
@MainActor
public struct OpenWindowAction {
    private let action: (String) -> Void

    internal init(action: @escaping (String) -> Void) {
        self.action = action
    }

    /// Opens the window with the specified ID.
    public func callAsFunction(id: String) {
        action(id)
    }
}

/// Environment key for the open window action.
private struct OpenWindowActionKey: EnvironmentKey {
    @MainActor
    static var defaultValue: OpenWindowAction {
        OpenWindowAction(action: { _ in
            #if DEBUG
                print("warning: openWindow(id:) called but no `Window` scenes exist")
            #endif
        })
    }
}

extension EnvironmentValues {
    /// An action that opens a window with the specified ID.
    @MainActor
    public var openWindow: OpenWindowAction {
        get { self[OpenWindowActionKey.self] }
        set { self[OpenWindowActionKey.self] = newValue }
    }
}
