import DefaultBackend
import SwiftBundlerRuntime
import SwiftCrossUI

@main
@HotReloadable
struct NotesApp: App {
    var body: some Scene {
        WindowGroup("Notes") {
            #hotReloadable {
                ContentView()
            }
        }
        .defaultSize(width: 800, height: 400)
    }
}
