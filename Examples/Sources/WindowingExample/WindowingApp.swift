import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@available(tvOS, unavailable)
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

// A demo displaying SwiftCrossUI's `View.sheet` modifier.
struct SheetDemo: View {
    @State var isPresented = false
    @State var isEphemeralSheetPresented = false
    @State var ephemeralSheetDismissalTask: Task<Void, Never>?

    var body: some View {
        Button("Open Sheet") {
            isPresented = true
        }
        Button("Show Sheet for 5s") {
            isEphemeralSheetPresented = true
            ephemeralSheetDismissalTask = Task {
                do {
                    try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
                    isEphemeralSheetPresented = false
                } catch {}
            }
        }
        .sheet(isPresented: $isPresented) {
            print("Root sheet dismissed")
        } content: {
            SheetBody()
                .presentationDetents([.height(250), .medium, .large])
                .presentationBackground(.green)
        }
        .sheet(isPresented: $isEphemeralSheetPresented) {
            ephemeralSheetDismissalTask?.cancel()
        } content: {
            Text("I'm only here for 5s")
                .padding(20)
                .presentationDetents([.medium])
                .presentationCornerRadius(10)
                .presentationBackground(.red)
        }
    }

    struct SheetBody: View {
        @State var isNestedSheetPresented = false
        @Environment(\.dismiss) var dismiss

        var body: some View {
            VStack {
                Text("Root sheet")
                Button("Present a nested sheet") {
                    isNestedSheetPresented = true
                }
                Button("Dismiss") {
                    dismiss()
                }
            }
            .padding()
            .sheet(isPresented: $isNestedSheetPresented) {
                print("Nested sheet dismissed")
            } content: {
                NestedSheetBody(dismissRoot: { dismiss() })
                    .presentationDetents([.height(250), .medium, .large])
            }
        }
    }

    struct NestedSheetBody: View {
        var dismissRoot: () -> Void

        @Environment(\.dismiss) var dismiss
        @State var showNextChild = false

        var body: some View {
            VStack {
                Text("Nested sheet")

                Button("Present another sheet") {
                    showNextChild = true
                }
                Button("Dismiss root sheet") {
                    dismissRoot()
                }
                Button("Dismiss") {
                    dismiss()
                }
            }
            .padding()
            .sheet(isPresented: $showNextChild) {
                print("Nested sheet dismissed")
            } content: {
                NestedSheetBody(dismissRoot: dismissRoot)
                    .presentationDetents([.height(250), .medium, .large])
            }
        }
    }
}

@main
@HotReloadable
struct WindowingApp: App {
    @State var title = "My window"
    @State var resizable = false
    @State var closable = true
    @State var minimizable = true

    var body: some Scene {
        WindowGroup(title) {
            #hotReloadable {
                VStack {
                    HStack {
                        Text("Window title:")
                        TextField("My window", text: $title)
                    }

                    Button(resizable ? "Disable resizing" : "Enable resizing") {
                        resizable.toggle()
                    }

                    Button(closable ? "Disable closing" : "Enable closing") {
                        closable.toggle()
                    }
                    .windowDismissBehavior(closable ? .enabled : .disabled)

                    Button(minimizable ? "Disable minimizing" : "Enable minimizing") {
                        minimizable.toggle()
                    }
                    .windowMinimizeBehavior(minimizable ? .enabled : .disabled)

                    Image(Bundle.module.bundleURL.appendingPathComponent("Banner.png"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)

                    Divider()

                    #if !os(tvOS)
                        FileDialogDemo()

                        Divider()
                    #endif

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
        #if !os(iOS) && !os(tvOS)
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
