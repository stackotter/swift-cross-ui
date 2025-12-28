/// An action that opens a window with the specified ID.
@MainActor
public struct OpenWindowAction {
    /// Opens the window with the specified ID.
    public func callAsFunction(id: String) {
        windowOpenFunctionsByID[id]?()
    }
}
