import Foundation
import GtkBackend
import SwiftCrossUI

#if canImport(FileDialog)
    import FileDialog
#endif

class FileViewerAppState: Observable {
    @Observed var file: URL? = nil
}

@main
struct FileViewerApp: App {
    typealias Backend = GtkBackend

    let identifier = "dev.stackotter.FileViewerApp"

    let state = FileViewerAppState()

    var body: some Scene {
        WindowGroup("File Viewer") {
            #if canImport(FileDialog)
                HStack {
                    VStack {
                        Text("Selected file: \(state.file?.path ?? "none")")

                        Button("Click") {
                            let dialog = FileDialog()
                            dialog.open { result in
                                guard case let .success(file) = result else {
                                    return
                                }
                                state.file = file
                            }
                        }
                    }.padding(10)
                }
            #else
                Text("FileDialog requires Gtk 4.10")
            #endif
        }
        .defaultSize(width: 500, height: 650)
    }
}
