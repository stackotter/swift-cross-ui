import SwiftCrossUI
import Foundation

class FileViewerAppState: Observable {
    @Observed var file: URL? = nil
}

@main
struct FileViewerApp: App {
    let identifier = "dev.stackotter.FileViewerApp"

    let state = FileViewerAppState()

    let windowProperties = WindowProperties(
        title: "File Viewer",
        defaultSize: WindowProperties.Size(500, 650),
        resizable: false
    )

    var body: some ViewContent {
        #if canImport(FileDialog)
        HStack {
            VStack {
                Text("Selected file: \(state.file?.path ?? "none")")

                Button("Click") {
                    let dialog = GtkFileDialog()
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
}
