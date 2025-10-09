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

// kind of a stress test for the dismiss action
struct SheetDemo: View {
    @State var isPresented = false
    @State var isShortTermSheetPresented = false

    var body: some View {
        Button("Open Sheet") {
            isPresented = true
        }
        Button("Show Sheet for 5s") {
            isShortTermSheetPresented = true
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000 * 5)
                isShortTermSheetPresented = false
            }
        }
        .sheet(isPresented: $isPresented) {
            print("sheet dismissed")
        } content: {
            SheetBody()
                .presentationDetents([.height(150), .medium, .large])
                .presentationDragIndicatorVisibility(.visible)
                .presentationBackground(.green)
        }
        .sheet(isPresented: $isShortTermSheetPresented) {
            Text("I'm only here for 5s")
                .padding(20)
                .presentationDetents([.height(150), .medium, .large])
                .presentationCornerRadius(10)
                .presentationBackground(.red)
        }
    }

    struct SheetBody: View {
        @State var isPresented = false
        @Environment(\.dismiss) var dismiss

        var body: some View {
            VStack {
                Text("Nice sheet content")
                    .padding(20)
                Button("I want more sheet") {
                    isPresented = true
                    print("should get presented")
                }
                Button("Dismiss") {
                    dismiss()
                }
                Spacer()
            }
            .sheet(isPresented: $isPresented) {
                print("nested sheet dismissed")
            } content: {
                NestedSheetBody(dismissParent: { dismiss() })
                    .presentationCornerRadius(35)
            }
        }

        struct NestedSheetBody: View {
            @Environment(\.dismiss) var dismiss
            var dismissParent: () -> Void
            @State var showNextChild = false

            var body: some View {
                Text("I'm nested. Its claustrophobic in here.")
                Button("New Child Sheet") {
                    showNextChild = true
                }
                .sheet(isPresented: $showNextChild) {
                    DoubleNestedSheetBody(dismissParent: { dismiss() })
                        .interactiveDismissDisabled()
                }
                Button("dismiss parent sheet") {
                    dismissParent()
                }
                Button("dismiss") {
                    dismiss()
                }
            }
        }
        struct DoubleNestedSheetBody: View {
            @Environment(\.dismiss) var dismiss
            var dismissParent: () -> Void

            var body: some View {
                Text("I'm nested. Its claustrophobic in here.")
                Button("dismiss parent sheet") {
                    dismissParent()
                }
                Button("dismiss") {
                    dismiss()
                }
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

                    Divider()

                    SheetDemo()
                        .padding(.bottom, 20)
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
        #if !os(iOS)
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
        #endif
    }
}
