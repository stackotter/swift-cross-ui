import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

// MARK: - Main App

@main
@HotReloadable
struct ChatbotApp: App {
    @State private var viewModel = ChatbotViewModel()
    
    var body: some Scene {
        WindowGroup("ChatBot") {
            #hotReloadable {
                ZStack {
                    // Main content with sidebar
                    HStack(spacing: 0) {
                        // Thread Sidebar - conditionally shown
                        if viewModel.showSidebar {
                            ThreadSidebarView(
                                threads: Binding(
                                    get: { viewModel.threads },
                                    set: { viewModel.threads = $0 }
                                ),
                                selectedThread: Binding(
                                    get: { viewModel.selectedThread },
                                    set: { viewModel.selectedThread = $0 }
                                ),
                                showSidebar: Binding(
                                    get: { viewModel.showSidebar },
                                    set: { viewModel.showSidebar = $0 }
                                ),
                                onNewThread: viewModel.createNewThread,
                                onSelectThread: viewModel.selectThread,
                                onDeleteThread: viewModel.deleteThread
                            )
                            .frame(width: 300)
                        }
                        
                        // Main chat area
                        MainChatView(viewModel: viewModel)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Settings Overlay
                    if viewModel.showSettings {
                        ChatSettingsDialog(
                            isPresented: Binding(
                                get: { viewModel.showSettings },
                                set: { viewModel.showSettings = $0 }
                            ),
                            selectedModel: Binding(
                                get: { viewModel.selectedLLM },
                                set: { viewModel.selectedLLM = $0 }
                            ),
                            openAIService: viewModel.openAIService,
                            apiKeyStorage: viewModel.apiKeyStorage,
                            onSave: viewModel.reloadAPIKey
                        )
                    }
                }
            }
        }
        .defaultSize(width: 1200, height: 800)
    }
}
