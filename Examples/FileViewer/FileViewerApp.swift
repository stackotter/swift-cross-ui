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

    let windowProperties = WindowProperties(
        title: "File Viewer",
        defaultSize: WindowProperties.Size(500, 650),
        resizable: false
    )

    var body: some View {
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
}
