import Foundation

/// Presents a 'Save file' dialog fit for selecting a save destination. Returns
/// `nil` if the user cancels the operation.
public struct PresentFileSaveDialogAction {
    let backend: any AppBackend
    let window: Any

    public func callAsFunction(
        title: String = "Save",
        message: String = "",
        defaultButtonLabel: String = "Save",
        initialDirectory: URL? = nil,
        showHiddenFiles: Bool = false,
        nameFieldLabel: String? = nil,
        defaultFileName: String? = nil
    ) async -> URL? {
        func chooseFile<Backend: AppBackend>(backend: Backend) async -> URL? {
            return await withCheckedContinuation { continuation in
                backend.runInMainThread {
                    backend.showSaveDialog(
                        fileDialogOptions: FileDialogOptions(
                            title: title,
                            defaultButtonLabel: defaultButtonLabel,
                            allowedContentTypes: [],
                            showHiddenFiles: showHiddenFiles,
                            allowOtherContentTypes: true,
                            initialDirectory: initialDirectory
                        ),
                        saveDialogOptions: SaveDialogOptions(
                            nameFieldLabel: nameFieldLabel,
                            defaultFileName: defaultFileName
                        ),
                        window: window as! Backend.Window
                    ) { result in
                        switch result {
                            case .success(let url):
                                continuation.resume(returning: url)
                            case .cancelled:
                                continuation.resume(returning: nil)
                        }
                    }
                }
            }
        }

        return await chooseFile(backend: backend)
    }
}
