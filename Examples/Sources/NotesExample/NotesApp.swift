import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

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
