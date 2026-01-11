/// An action that opens a window with the specified ID.
@MainActor
public struct OpenWindowAction {
    let backend: any AppBackend

    /// Opens the window with the specified ID.
    public func callAsFunction(id: String) {
        guard backend.supportsMultipleWindows else {
            logger.warning(
                """
                openWindow(id:) called but the backend doesn't support \
                multi-window, ignoring
                """
            )
            return
        }

        guard let openWindow = Self.openFunctionsByID[id] else {
            logger.warning(
                """
                openWindow(id:) called with an ID that does not have an \
                associated window
                """,
                metadata: ["id": "\(id)"]
            )
            return
        }
        openWindow()
    }

    // FIXME: we should make this a preference instead, if we can get those to
    //   propagate beyond the scene level
    static var openFunctionsByID: [String: @Sendable @MainActor () -> Void] = [:]
}
