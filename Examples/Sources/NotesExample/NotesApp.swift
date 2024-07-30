import SelectedBackend
import SwiftBundlerRuntime
import SwiftCrossUI

@main
@HotReloadable
struct NotesApp: App {
    let identifier = "dev.stackotter.NotesApp"

    var body: some Scene {
        WindowGroup("Notes") {
            #hotReloadable {
                ContentView()
            }
        }
        .defaultSize(width: 400, height: 200)
    }
}
