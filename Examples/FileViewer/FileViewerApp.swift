import SwiftCrossUI
import Foundation

class FileViewerAppState: AppState {
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
        HStack {
            VStack {
                Text("Selected file: \(state.file?.path ?? "none")")

                WindowReader { window in
                    Button("Click") {
                        state.file = FileChooser.present(window)
                    }
                }
            }.padding(10)
        }
    }
}
