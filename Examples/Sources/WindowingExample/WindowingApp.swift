import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

struct FileDialogDemo: View {
    @State var selectedFile: URL? = nil
    @State var saveDestination: URL? = nil

    @Environment(\.chooseFile) var chooseFile
    @Environment(\.chooseFileSaveDestination) var chooseFileSaveDestination

    var body: some View {
        Text("File dialog demo")
            .font(.system(size: 18))

        if let selectedFile {
            Text("Selected file: \(selectedFile.path)")
        } else {
            Text("No file selected")
        }

        if let saveDestination {
            Text("Save destination: \(saveDestination.path)")
        }

        HStack {
            Button("Open") {
                Task {
                    guard let file = await chooseFile() else {
                        return
                    }
                    selectedFile = file
                }
            }

            Button("Save") {
                Task {
                    guard let file = await chooseFileSaveDestination() else {
                        return
                    }
                    saveDestination = file
                }
            }
        }
    }
}

struct AlertDemo: View {
    @Environment(\.presentAlert) var presentAlert

    var body: some View {
        Text("Alert demo")
            .font(.system(size: 18))

        Button("Present error") {
            Task {
                await presentAlert("Failed to succeed")
            }
        }
    }
}

@main
@HotReloadable
struct WindowingApp: App {
    @State var title = "My window"
    @State var resizable = false

    var body: some Scene {
        WindowGroup(title) {
            #hotReloadable {
                VStack {
                    HStack {
                        Text("Window title:")
                        TextField("My window", text: $title)
                    }

                    Button(resizable ? "Disable resizing" : "Enable resizing") {
                        resizable = !resizable
                    }

                    Image(Bundle.module.bundleURL.appendingPathComponent("Banner.png"))

                    Divider()

                    FileDialogDemo()

                    Divider()

                    AlertDemo()
                }
                .padding(20)
            }
        }
        .defaultSize(width: 500, height: 500)
        .windowResizability(resizable ? .contentMinSize : .contentSize)
        .commands {
            CommandMenu("Demo menu") {
                Button("Menu item") {}

                Menu("Submenu") {
                    Button("Item 1") {}
                    Button("Item 2") {}
                }
            }
        }

        WindowGroup("Secondary window") {
            #hotReloadable {
                Text("This a secondary window!")
                    .padding(10)
            }
        }
        .defaultSize(width: 200, height: 200)
        .windowResizability(.contentMinSize)

        WindowGroup("Tertiary window") {
            #hotReloadable {
                Text("This a tertiary window!")
                    .padding(10)
            }
        }
        .defaultSize(width: 200, height: 200)
        .windowResizability(.contentMinSize)
    }
}
