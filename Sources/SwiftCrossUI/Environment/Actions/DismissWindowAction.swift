/// An action that closes the enclosing window.
///
/// Use the `dismissWindow` environment value to get an instance of this action,
/// then call it to close the enclosing window.
///
/// Example usage:
/// ```swift
/// struct ContentView: View {
///     @Environment(\.dismissWindow) var dismissWindow
///
///     var body: some View {
///         VStack {
///             Text("Window Content")
///             Button("Close") {
///                 dismissWindow()
///             }
///         }
///     }
/// }
/// ```
@MainActor
public struct DismissWindowAction {
    private let action: @Sendable @MainActor () -> Void

    nonisolated internal init(action: @escaping @Sendable @MainActor () -> Void) {
        self.action = action
    }

    /// Closes the enclosing window.
    public func callAsFunction() {
        action()
    }
}

/// Environment key for the ``EnvironmentValues/dismissWindow-7td46`` action.
private struct DismissWindowActionKey: EnvironmentKey {
    static var defaultValue: DismissWindowAction {
        DismissWindowAction(action: {
            #if DEBUG
                logger.warning("dismissWindow() accessed outside of a window's scope")
            #endif
        })
    }
}

extension EnvironmentValues {
    /// Closes the enclosing window.
    @MainActor
    public var dismissWindow: DismissWindowAction {
        get { self[DismissWindowActionKey.self] }
        set { self[DismissWindowActionKey.self] = newValue }
    }
}
