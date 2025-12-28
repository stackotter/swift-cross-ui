import Foundation

/// Reveals a file in the system's file manager. This opens
/// the file's enclosing directory and highlights the file.
@MainActor
public struct RevealFileAction {
    let action: (URL) -> Void

    init?<Backend: AppBackend>(backend: Backend) {
        guard backend.canRevealFiles else {
            return nil
        }

        action = { file in
            do {
                try backend.revealFile(file)
            } catch {
                print("warning: Failed to reveal file: \(error)")
            }
        }
    }

    public func callAsFunction(_ file: URL) {
        action(file)
    }
}
