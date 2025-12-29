import Foundation

/// Reveals a file in the system's file manager. This opens
/// the file's enclosing directory and highlighting the file.
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
                logger.warning("failed to reveal file", metadata: [
                    "url": "\(file)",
                    "error": "\(error)",
                ])
            }
        }
    }

    public func callAsFunction(_ file: URL) {
        action(file)
    }
}
