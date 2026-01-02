/// An action that opens a window with the specified ID.
@MainActor
public struct OpenWindowAction {
    let backend: any AppBackend

    /// Opens the window with the specified ID.
    public func callAsFunction(id: String) {
        guard backend.supportsMultipleWindows else {
            print(
                """
                warning: openWindow(id:) called but the backend doesn't \
                support multi-window, ignoring
                """
            )
            return
        }

        guard let openWindow = windowOpenFunctionsByID[id] else {
            // FIXME: replace with logger.warning once that PR's merged
            print(
                """
                warning: openWindow(id:) called with an ID that does not have \
                an associated window: '\(id)'
                """
            )
            return
        }
        openWindow()
    }
}

// FIXME: we should make this a preference instead, if we can get those to
//   propagate beyond the scene level
var windowOpenFunctionsByID: [String: @Sendable @MainActor () -> Void] = [:]
