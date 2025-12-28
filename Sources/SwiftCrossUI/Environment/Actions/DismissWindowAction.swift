/// An action that closes the current window.
///
/// Use the `dismissWindow` environment value to get an instance of this action,
/// then call it to close the current window .
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
    let backend: any AppBackend
    let window: MainActorBox<Any?>

    /// Dismisses the current presentation context.
    public func callAsFunction() {
        func closeWindow<Backend: AppBackend>(backend: Backend) {
            guard let window = window.value else {
                print("warning: dismissWindow() called outside of a window")
                return
            }
            backend.close(window: window as! Backend.Window)
        }

        closeWindow(backend: backend)
    }
}
